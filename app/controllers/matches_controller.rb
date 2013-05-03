class MatchesController < ApplicationController
  layout 'team'

  def index
    @team = Team.find(params[:team_id])
    @matches = @team.matches
  end

  def new
    @team = Team.find(params[:team_id])
    @match = @team.matches.build
    Chronic.time_class = Time.zone
    @match.date = Chronic.parse('this 02:30 PM')
  end

  def edit
    @match = Match.find(params[:id])
    @team = @match.team
  end

  def notify
    @match = Match.find(params[:id])

    if !@match.notified_team?
      if @match.created?
        MatchMailer.match_scheduled(@match).deliver
      else
        MatchMailer.match_updated(@match, @match.recent_changes).deliver
      end

      @match.notified!
      redirect_to team_matches_url(@match.team), :notice => 'Notification email sent to team'
    else
      redirect_to team_matches_url(@match.team), :notice => 'Team has already been notified'
    end
  end

  def notify_lineup
    @match = Match.find(params[:id])

    if !@match.notified_team_lineup?
      if @match.lineup_created?
        MatchLineupMailer.lineup_set(@match).deliver
      else
        # TODO gotta get the changes of the lineup
        MatchLineupMailer.lineup_updated(@match, []).deliver
      end

      @match.notified_lineup!
      redirect_to team_matches_url(@match.team), :notice => 'Notification email sent to team'
    else
      redirect_to team_matches_url(@match.team), :notice => 'Team has already been notified of the lineup'
    end
  end

  def create
    @team = Team.find(params[:team_id])
    @match = @team.matches.build(permitted_params.match)

    if @match.save
      redirect_to team_matches_url(@team), :notice => 'Match created'
    else
      render :new
    end
  end

  def update
    @match = Match.find(params[:id])

    if @match.update_attributes(permitted_params.match)
      @match.reset_notified! if @match.previous_changes.present?
      if params[:commit] == 'Save results'
        redirect_to team_results_url(@match.team), :notice => 'Results updated'
      else
        # detect lineup changes and only reset then
        @match.reset_notified_lineup!
        redirect_to team_matches_url(@match.team), :notice => 'Match updated'
      end
    else
      @team = @match.team
      render :edit
    end
  end

  def destroy
    @match = Match.find(params[:id])
    @match.destroy

    redirect_to team_matches_url(@match.team), :notice => 'Match deleted'
  end
end


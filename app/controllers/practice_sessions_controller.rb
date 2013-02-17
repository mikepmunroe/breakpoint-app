class PracticeSessionsController < ApplicationController
  def create
    @practice = Practice.find(params[:practice_id])
    # TODO authorize practice
    @practice_session = @practice.practice_sessions.build(params[:practice_session])
    @practice_session.user = current_user
    @practice_session.save

    redirect_to @practice.season
  end

  def destroy
    @practice = Practice.find(params[:practice_id])
    @practice_session = PracticeSession.find(params[:id])
    authorize @practice_session

    @practice_session.destroy

    redirect_to @practice.season
  end
end


class ChallengesController < ApplicationController
  before_filter :get_question, :only => [:show, :edit, :update]
  before_filter :authorize_user!, :except => [:index, :result]
  
  def index
    @questions = Question.all
  end
  def new
    @question = Question.new(qtype:params[:type]) 
    ajax_no_layout
  end
  def create
    @question = Question.new(params[:question])
    if @question.save
      redirect_to challenge_path(@question)
    else
      render 'new', :status => 422
    end
  end
  def show
  end
  def edit
  end
  def result
    @questions = Question.all
    @answers = params[:answers]
    @stat = Question.check_answers(@answers, @questions)
  end
  def update
    if @question.update_attributes(params[:question])
      redirect_to challenge_path(@question)
    else
      redirect_to :back
    end
  end
  private
  def get_question
    @question = Question.find(params[:id])
  end
  
end

require 'spec_helper'

describe VisitorQuestionsController do
  render_views
  describe 'pulic' do
    
    context 'GET index' do
      
      it 'assigns new @question' do
        get :index
        assigns(:question).should be_new_record
      end
      
      it 'should renders index' do
        get :index
        response.should render_template :index
      end
      
      it 'assigns @questions with 10 responded' do
        size = 14
        sym = "responded_visitor_question"
        qs = size.times.inject([]) do |s, idx| 
          s << fgc(sym.to_sym, :updated_at => Time.now + (idx * 10) )
        end
        5.times{ FactoryGirl.create(:visitor_question) }
        get :index
        assigns(:questions).should =~ qs[(size-10)...size]
        assigns(:questions).should have(10).items
      end
      
    end
  
    describe 'POST create' do
      
      before(:each) do
        request.env["HTTP_REFERER"] = asks_url
      end
      
      it 'creates new @question' do
        post :create, :visitor_question => FactoryGirl.attributes_for(:visitor_question)
        flash[:notice].should == "Thanks for your submission"
        response.should redirect_to asks_url
      end
      
      it 'fails to create new @question' do
        post :create, :visitor_question => {:email => 'abc@abc.com'}
        flash[:notice].should == "Please provide valid email and description"
        response.should redirect_to asks_url
      end
      
    end
    
    context 'GET show' do
      
      it 'display details of the question' do
        q = FactoryGirl.create(:visitor_question)
        get :show, :id => q.id
        assigns(:question).should == q
        response.should render_template :show
        response.body.should have_content q.email 
        response.body.should have_content q.description
      end
      
    end
    
    describe 'GET page' do
      it 'is ajax call' do
        xhr :get, :page, :number => 1
        @layouts.keys.should == [nil]
      end
      it 'is web url call' do
        get :page, :number => 1
        @layouts.keys.should_not == [nil]
        response.should render_template(:page)
      end
      
    end
  end
  
  describe 'admin' do
    let(:q) { FactoryGirl.create(:visitor_question) }
    before(:each) do
      login_admin
    end
    
    describe 'GET not_respond/pending' do
      
      before(:each) do
        qs = 5.times.inject([]) { |s| s << FactoryGirl.create(:visitor_question) }
        3.times{ FactoryGirl.create(:responded_visitor_question) }
        get :not_respond
      end
      
      it 'should has all the questions without responded' do
        assigns(:questions).should have(5).items
        response.should render_template :not_respond
        response.body.should have_content 'Pending Questions'
      end 
      
    end
    describe 'GET respond' do
      # check with valid id and without
      before(:each) do
        get :respond, :id => q.id
      end
      
      it 'shows the respond page' do
        response.should render_template :respond
      end
    end
    
    describe 'POST responded' do
      before(:each) do
        request.env["HTTP_REFERER"] = respond_ask_url(q)
        post :responded,
             :id => q.id,
             :visitor_question => { :respond => respond }
      end
      describe 'update respond success' do
        let(:respond) { 'answered' }
        it 'should go pending page' do
          response.should redirect_to not_respond_asks_url
        end
        
        it 'should notice with message "Question answered"' do
          flash[:notice].should have_content 'Question answered'
        end
        
      end
      
      describe 'update respond fails' do
        let(:respond) { "" }
        it 'should go back' do
          response.should redirect_to :back
        end
        
        it 'should notice with message "Respond text too short"' do
          flash[:notice].should have_content 'Respond text too short'
        end
        
      end
      
    end
  end
    
  describe 'regular user' do
    
    before(:each) do
      login_user
    end
    
    describe 'GET not_respond/pending' do
      
      before(:each) do
        get :not_respond
      end
      
      it 'should redirect to home' do
        response.should redirect_to root_url
      end
      
    end
    
  end
    
  describe 'not sign in' do
    
    describe 'GET not_respond/pending' do
      
      before(:each) do
        controller.stub(:user_signed_in?).and_return(false)
        get :not_respond
      end
      
      it 'should redirect to sign in' do
        response.should redirect_to new_user_session_url
      end
      
    end
    
  end
  
end

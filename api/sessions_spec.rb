require 'spec_helper'

describe "Sessions_API" do
  context 'sending post to /session' do
    it 'returns response.status == 422 Unprocessable Entity when email not found' do
      post '/session', { :session => {:email => 'me@example.com', :password => 'password123', :source => 'web'} }, { format: "json", accept: "application/json" }

      # assertions
      expect(response.status).to eq(422)
    end
    it 'returns response.body == {"email":["not found"]} when email not found' do
      post '/session', { :session => { :email => 'me@example.com', :password => 'password123', :source => 'web' } }, { format: "json", accept: "application/json" }
      
      # assertions
      expect(response.header['Content-Type']).to include('json')
      expect(response.body).to eq('{"email":["not found"]}')
    end
    it 'returns response.status == 201 Created response when email found and password matches' do
      
      # create a new person entity
      person = FactoryGirl.create(:person)


      # log the new person in using /session api call
        post "/session", { :session => {:email => 'me@example.com', :password => 'password123', :source => 'web'} }, { format: "json", accept: "application/json" }
        
        # assertions
        # session created
        expect(response.status).to eq(201)
        
        get "/session"
        expect(session).to_not be(nil)
    end
    it 'returns response.status == 422 Unprocessable Entity response for blank email when email blank' do
     post '/session', { :session => {:email => '', :password => 'password123', :source => 'web'} }, { format: "json", accept: "application/json" }

        # assertions
        expect(response.status).to eq(422)
    end
    it 'returns resposne.body ~= {"email":["not found", "can\'t be blank"]} when email blank' do
      post '/session', { :session => {:email => '', :password => 'password123', :source => 'web'} }, { format: "json", accept: "application/json" }


        parsed_body = JSON.parse(response.body);
        parsed_body['email'].should include("can't be blank")
        parsed_body['email'].should include("not found")
    end
  end
  context 'sending delete to /session' do
    it 'returns no json content' do
      person = FactoryGirl.create(:person)
      post '/session', { :session => {:email => 'me@example.com', :password => 'password123', :source => 'web'} }, { format: "json", accept: "application/json" }
      
      expect{ delete '/session' }.to_not raise_error
      #expect(response.header['Content-Type']).to_not include('json')

      #expect(response.status).to eq(204)

    end   
  end
  describe '#show' do
    it 'shows the current session' do
      person = FactoryGirl.create(:person)
      post '/session', { :session => {:email => 'me@example.com', :password => 'password123', :source => 'web'} }, { format: "json", accept: "application/json" }
      @id = person.id
      @token = session[:token]

      get '/session', {}, { format: "json", authorization: "Token #{@token}", accept: "application/json"}
      
      expect(response.status).to eq(200)
      expect(response.header['Content-Type']).to include('application/json')
      expect(response.body).to include('Fred')
    end
    it 'does not show the current session' do
      expect{
        get '/session', {}, { format: "json", authorization: "Token c2122d98baf58aef6bc91f1f7d3619c4", accept: "application/json"}
      }.to raise_error
    end
  end
end










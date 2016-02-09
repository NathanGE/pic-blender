require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "comments#create action" do

    it "should allow user to create comments on grams" do
      gram = FactoryGirl.create(:gram)
      u = FactoryGirl.create(:user)
      sign_in u
      post :create, gram_id: gram.id, comment: { message: "awesome gram" }
      expect(response).to redirect_to root_path
      expect(u.comments.length).to eq 1
      expect(gram.comments.first.message).to eq "awesome gram"
    end

    it "should require a user to be logged in to comment on a gram" do
      gram =  FactoryGirl.create(:gram)
      post :create, gram_id: gram.id, comment: { message: "awesome gram" }
      expect(response).to redirect_to new_user_session_path
    end

    it "should return a 404 error message if the gram is not found" do
      u = FactoryGirl.create(:user)
      sign_in u
      post :create, gram_id: "YOLO", comment: { message: "awesome gram" }
      expect(response).to have_http_status :not_found
    end
  end

end

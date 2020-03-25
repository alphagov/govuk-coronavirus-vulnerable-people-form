RSpec.shared_examples "redirections" do
  it "redirects to start if no session data" do
    get :show
    expect(response).to redirect_to(live_in_england_path)
  end
end

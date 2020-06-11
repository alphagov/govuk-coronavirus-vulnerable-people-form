# typed: false
RSpec.shared_examples "redirections" do
  it "redirects to start if no session data" do
    get :show
    expect(response).to redirect_to(live_in_england_path)
  end
end

RSpec.shared_examples "session expiry" do
  it "redirects to session expired page if the session has timed out" do
    allow(controller).to receive(:submit).and_raise(ActionController::InvalidAuthenticityToken)

    post :submit
    expect(response).to redirect_to(session_expired_path)
  end
end

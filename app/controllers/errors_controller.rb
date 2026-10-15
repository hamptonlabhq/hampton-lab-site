# Branded 404 page. deploy_github.sh saves it as 404.html in the static build,
# which Cloudflare Pages serves for every unknown URL.
class ErrorsController < ApplicationController
  allow_unauthenticated_access
  before_action { @noindex = true }

  def not_found
    render status: :not_found
  end
end

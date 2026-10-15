module ApplicationHelper
  # Production is a static mirror served from this origin, so absolute URLs in
  # canonical / Open Graph / JSON-LD tags must point here, not at the local server.
  SITE_URL = "https://hamptonlab.com".freeze
  SITE_NAME = "Hampton Lab".freeze
  DEFAULT_TITLE = "Hampton Lab: A Website Design and Management Company".freeze
  DEFAULT_DESCRIPTION = "We design, develop, and manage beautiful websites for $50/mo.".freeze
  CONTACT_EMAIL = "waseem.mehany@hamptonlab.com".freeze

  def page_title
    content_for(:title).presence || DEFAULT_TITLE
  end

  def page_description
    content_for(:description).presence || DEFAULT_DESCRIPTION
  end

  # Canonical URL for the current page. Views set content_for(:canonical_path)
  # to the trailing-slash path the static mirror serves (e.g. "/process/").
  def canonical_url
    "#{SITE_URL}#{content_for(:canonical_path).presence || "/"}"
  end

  def site_url(path = "/")
    "#{SITE_URL}#{path}"
  end

  # Renders a JSON-LD <script> tag. Inert data, never executed by the browser.
  def json_ld_tag(data)
    tag.script(ERB::Util.json_escape(JSON.generate(data)).html_safe, type: "application/ld+json")
  end

  def organization_json_ld
    {
      "@type" => "ProfessionalService",
      "@id" => site_url("/#organization"),
      "name" => SITE_NAME,
      "url" => site_url,
      "logo" => site_url("/logo-favicon-black.png"),
      "image" => site_url("/thumbnail.png"),
      "email" => CONTACT_EMAIL,
      "description" => DEFAULT_DESCRIPTION,
      "founder" => { "@id" => site_url("/founder_letter/#founder") },
      "knowsAbout" => [ "Website design", "Website development", "Website management", "Branding" ]
    }
  end

  def website_json_ld
    {
      "@type" => "WebSite",
      "@id" => site_url("/#website"),
      "name" => SITE_NAME,
      "url" => site_url,
      "inLanguage" => "en",
      "publisher" => { "@id" => site_url("/#organization") }
    }
  end

  def founder_json_ld
    {
      "@type" => "Person",
      "@id" => site_url("/founder_letter/#founder"),
      "name" => "Waseem Mehany",
      "jobTitle" => "Founder",
      "email" => CONTACT_EMAIL,
      "worksFor" => { "@id" => site_url("/#organization") }
    }
  end

  # The sign-in, password and blog pages. They are not part of the static build
  # and are the only pages that load Turbo.
  def admin_page?
    controller_name.in?(%w[ blogs sessions passwords ])
  end

  # Pages that render or edit Action Text content and therefore need the trix
  # editor JS and actiontext.css. The public marketing pages don't.
  def rich_text_page?
    controller_name == "blogs"
  end

  # Every stylesheet in app/assets, minus actiontext.css on pages that don't
  # need it.
  def page_stylesheets
    rich_text_page? ? app_stylesheets_paths : app_stylesheets_paths - [ "actiontext.css" ]
  end
end

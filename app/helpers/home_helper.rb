module HomeHelper
  # Project screenshots shown on the home page. Each image ships in two sizes with
  # the exact same aspect ratio (so layout never changes): the full file for 2x
  # screens and a half-size file for 1x screens.
  #   name => [full width, full height, small width]
  PROJECT_IMAGES = {
    "rockwood-construction"   => [ 1600, 1000, 800 ],
    "la-years"                => [ 2324, 1754, 1162 ],
    "sancerra"                => [ 1600, 1000, 800 ],
    "cornerstone-real-estate" => [ 1600, 1000, 800 ],
    "dr-tim-chiu"             => [ 1600, 1000, 800 ],
    "europe-treks"            => [ 2324, 1754, 1162 ]
  }.freeze

  # Displayed at 100% width below 1024px, 8/12 columns (max 800px) above.
  PROJECT_IMAGE_SIZES = "(max-width: 1024px) 100vw, 800px".freeze

  # The first project image is the desktop LCP element, so it loads eagerly with
  # high priority; the rest are below the fold and load lazily.
  def project_image(name, first: false)
    width, height, small = PROJECT_IMAGES.fetch(name)
    image_tag "#{name}.jpg",
      srcset: { "#{name}-#{small}.jpg" => "#{small}w", "#{name}.jpg" => "#{width}w" },
      sizes: PROJECT_IMAGE_SIZES,
      width: width, height: height,
      decoding: "async",
      loading: (first ? "eager" : "lazy"),
      fetchpriority: (first ? "high" : nil)
  end
end

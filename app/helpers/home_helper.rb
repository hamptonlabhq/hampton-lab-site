module HomeHelper
  # Project screenshots shown on the home page. Each image ships in two sizes with
  # the exact same aspect ratio (so layout never changes): the full file for 2x
  # screens and a half-size file for 1x screens.
  #   name => [full width, full height, small width]
  PROJECT_IMAGES = {
    "rockwood-construction"   => [ 1600, 1000, 800 ],
    "la-years"                => [ 1600, 1200, 800 ],
    "sancerra"                => [ 1600, 1000, 800 ],
    "cornerstone-real-estate" => [ 1600, 1000, 800 ],
    "dr-tim-chiu"             => [ 1600, 1000, 800 ],
    "europe-treks"            => [ 1600, 1200, 800 ]
  }.freeze

  # These were laid out at their original 2324x1754 ratio. Their files are now
  # 4:3, so this class keeps the old box (see projects.css) and object-fit: cover
  # trims the ~0.6% difference instead of shifting the layout.
  LEGACY_RATIO_IMAGES = %w[ la-years europe-treks ].freeze

  # Displayed at 100% width below 1024px, 8/12 columns (max 800px) above.
  PROJECT_IMAGE_SIZES = "(max-width: 1024px) 100vw, 800px".freeze

  # The first project image is the desktop LCP element, so it loads eagerly with
  # high priority; the rest are below the fold and load lazily.
  #
  # Every JPG has a WebP twin of the same name (about half the size), offered
  # through <picture>; browsers without WebP fall back to the JPG.
  def project_image(name, alt:, first: false)
    width, height, small = PROJECT_IMAGES.fetch(name)
    tag.picture do
      tag.source(type: "image/webp", sizes: PROJECT_IMAGE_SIZES,
        srcset: "#{image_path("#{name}-#{small}.webp")} #{small}w, #{image_path("#{name}.webp")} #{width}w") +
      image_tag("#{name}.jpg", alt: alt,
        class: ("project__img--legacy-ratio" if LEGACY_RATIO_IMAGES.include?(name)),
        srcset: { "#{name}-#{small}.jpg" => "#{small}w", "#{name}.jpg" => "#{width}w" },
        sizes: PROJECT_IMAGE_SIZES,
        width: width, height: height,
        decoding: "async",
        loading: (first ? "eager" : "lazy"),
        fetchpriority: (first ? "high" : nil))
    end
  end
end

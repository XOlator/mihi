# Start with creating a fake exhibition we can control
# Creation and management section to come later

words = %w(Neutra chillwave literally photo booth High Life mixtape you probably haven't heard of them before they sold out jean shorts cliche mlkshk Letterpress fap DIY iPhone Terry Richardson Keytar literally sartorial Terry Richardson Portland tofu direct trade retro ethical tumblr plaid typewriter gluten-free Plaid Bushwick try-hard cornhole trust fund helvetica McSweeney's 3 wolf moon meggings blue bottle small batch thundercats mlkshk Single-origin coffee letterpress occupy craft beer Schlitz ennui Tonx hoodie vinyl Portland Bushwick Bushwick you probably haven't heard of them umami 3 wolf moon art party messenger bag seitan shoreditch flannel organic hashtag master cleanse raw denim pour-over Biodiesel mumblecore kogi umami chambray fanny pack semiotics kale chips kitsch hashtag synth keffiyeh you probably haven't heard of them raw denim Hella selvage High Life plaid cliche Williamsburg polaroid Banksy narwhal organic literally Vice Butcher pickled VHS cliche bicycle rights fingerstache Banksy locavore dreamcatcher sriracha raw denim Kogi irony lo-fi bitters pitchfork skateboard gluten-free sustainable hella chillwave ethnic squid post-ironic typewriter Actually letterpress scenester pork belly semiotics pour-over shoreditch food truck art party Terry Richardson tumblr viral Pinterest banh mi cliche mumblecore tofu hoodie Tonx Skateboard gentrify fashion axe you probably haven't heard of them retro food truck banh mi 3 wolf moon gluten-free DIY Brooklyn locavore authentic lomo Pickled next level shoreditch aesthetic you probably haven't heard of them PBR umami small batch Ugh synth chillwave sustainable gastropub Flannel Banksy keffiyeh Wes Anderson ugh High Life put a bird on it hoodie 8-bit whatever tattooed stumptown Schlitz Kogi tote bag pug Cosby sweater forage asymmetrical four loko master cleanse post-ironic bicycle rights narwhal scenester letterpress 3 wolf moon put a bird on it PBR tumblr fanny pack lo-fi Echo Park pork belly actually ethical fixie semiotics pop-up gastropub mlkshk American apparel pitchfork whatever narwhal wayfarers craft beer Portland ennui authentic Terry Richardson tote bag four loko forage Williamsburg helvetica literally Mixtape ethical seitan ennui Try-hard vinyl asymmetrical Wes Anderson 8-bit flexitarian forage twee Neutra Blog craft beer Carles tumblr Flexitarian locavore cred wolf typewriter Lo-fi tousled church-key locavore master cleanse food truck narwhal letterpress authentic gastropub artisan Flannel gastropub vinyl 8-bit raw denim Odd Future gluten-free Schlitz shabby chic kogi small batch sriracha art party sustainable master cleanse Irony pork belly Pinterest single-origin coffee keytar polaroid shabby chic tousled Vice Bushwick cray hoodie fingerstache Etsy Salvia fap Bushwick Wes Anderson)

[Exhibition, ExhibitionPiece, PieceText, PiecePage, PiecePageEvent, PieceThumbnail, Section, ExhibitionUser].each do |m|
  m.all.each{|v| v.destroy rescue nil}
end

@exhibition = Exhibition.create(
  title: "Before They Were FAT", 
  subtitle: words.sample(3).join(' ').capitalize, 
  excerpt: words.sample(20).join(' ').capitalize, 
  description: words.sample(100).join(' ').capitalize
)


list = {
  evan: {
    title: "Evan Roth",
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
      {
        type:  :text,
        title: 'Evan Roth',
        content: words.sample(100).join(' ').capitalize,
      },
      {
        type:  :page,
        title: 'All City Council',
        content: words.sample(100).join(' ').capitalize,
        url: 'http://ni9e.com/acc/acc_main.php',
        timeline_year: '2004'
      },
      {
        type:  :page,
        title: 'Graffiti Taxonomy',
        content: words.sample(100).join(' ').capitalize,
        url: 'http://ni9e.com/graf_taxonomy.php',
        timeline_year: '2004'
      },
      {
        type:  :page,
        title: 'BAD ASS MOTHER FUCKER',
        content: words.sample(100).join(' ').capitalize,
        url: 'http://ni9e.com/bad_ass_mother_fucker.php',
        timeline_year: '2005'
      },
      {
        type:  :page,
        title: 'White Glove Tracking',
        content: words.sample(100).join(' ').capitalize,
        url: 'http://ni9e.com/white_glove_tracking.php',
        timeline_year: '2007'
      }
    ]
  },

  # JAMES
  james: {
    title: 'James Powderly',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
      # TODO
    ]
  },

  # JOHN J
  john: {
    title: 'Aram Bartholl',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
      # TODO
    ]
  },

  # JONAH
  jonah: {
    title: 'Jonah Peretti',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
      {
        type:  :text,
        title: 'Jonah Peretti',
        content: words.sample(100).join(' ').capitalize,
      },
      {
        type:  :page,
        title: "Nike Sweatshop Emails",
        content: words.sample(100).join(' ').capitalize,
        url: 'http://www.shey.net/niked.html',
        timeline_year: '2001',
        events: []
      },
      {
        type:  :page,
        title: "Huffington Post",
        content: words.sample(100).join(' ').capitalize,
        url: 'http://web.archive.org/web/20050510002539/http://www.huffingtonpost.com/',
        timeline_year: '2005',
        events: []
      },
    ]
  },

  # JAMIE
  jamie: {
    title: 'Jamie Wilkinson',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
      {
        type:  :text,
        title: 'Jamie Wilkinson',
        content: words.sample(100).join(' ').capitalize,
      },
      {
        type:  :page,
        title: "Music Blackhole",
        content: words.sample(100).join(' ').capitalize,
        url: 'http://jamiedubs.com/musicblackhole/',
        timeline_year: '2006',
        events: []
      },
    ]
  },

  # BENNETT
  bennett: {
    title: 'Bennett Williamson',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
      # TODO
    ]
  },

  # STEVE
  # steve: {
  #   title: 'Steve Lambert',
  #   subtitle: words.sample(3).join(' ').capitalize, 
  #   excerpt: words.sample(20).join(' ').capitalize, 
  #   description: words.sample(100).join(' ').capitalize,
  #   pieces: [
  #     # TODO
  #   ]
  # },

  # BORNA
  borna: {
    title: 'Borna Sammak',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
      # TODO
    ]
  },

  # TODD P
  # todd_p: {
  #   title: 'Todd Polenberg',
  #   subtitle: words.sample(3).join(' ').capitalize, 
  #   excerpt: words.sample(20).join(' ').capitalize, 
  #   description: words.sample(100).join(' ').capitalize,
  #   pieces: [
  #     # TODO
  #   ]
  # },

  # THEO
  theo: {
    title: 'Theo Watson',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
      # TODO
    ]
  },

  # BACA
  baca: {
    title: 'Mike Baca',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
      # TODO
    ]
  },

  # MICHAEL F
  michael: {
    title: 'Michael Frumin',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
      # TODO
    ]
  },

  # ZACH
  zach: {
    title: 'Zach Lieberman',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
      # TODO
    ]
  },

  # MICHELLE ?
  # michelle: {
  #   title: 'Michelle Kempner',
  #   subtitle: words.sample(3).join(' ').capitalize, 
  #   excerpt: words.sample(20).join(' ').capitalize, 
  #   description: words.sample(100).join(' ').capitalize,
  #   pieces: [
  #     # TODO
  #   ]
  # },

  # TOBI ?
  tobi: {
    title: 'Tobias Leingruber',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
      # TODO
    ]
  },

  # GERRY (1/10/08)
  gerry: {
    title: 'Geraldine Juárez',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
      # TODO
    ]
  },

  # BECKY (03/10/08)
  becky: {
    title: 'Becky Stern',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
      # TODO
    ]
  },

  # RANDY (7/20/08)
  randy: {
    title: 'Randy Sarafan',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
      # TODO
    ]
  },

  # ARAM (2/7/09)
  aram: {
    title: 'Aram Bartholl',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
      # TODO
    ]
  },

  # GREG (5/12/09)
  greg: {
    title: 'Greg Leuch',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
      {
        type:  :text,
        title: 'Greg Leuch',
        content: words.sample(100).join(' ').capitalize,
      },
      {
        type:  :page,
        title: "Ctrl+F'd",
        content: words.sample(100).join(' ').capitalize,
        url: 'http://gleu.ch/projects/ctrl-f-d',
        timeline_year: '2009',
        events: [
          {type: :scroll, array: [0], timeout: 6000},
          {type: :popup, array: ['section.statement a.button'], timeout: 3000, text: "See Ctrl+F'd in action by clicking the button."},
          {type: :clickthrough, array: ['section.statement a.button'], timeout: 3000}
        ]
      },
      {
        type:  :page,
        title: "FuckFlickr",
        content: words.sample(100).join(' ').capitalize,
        url: 'http://gleu.ch/projects/fuckflickr',
        timeline_year: '2008'
      },
    ]
  },

  # MOOT (?/?/09)
  moot: {
    title: 'Christopher "Moot" Poole',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
    ]
  },

  # MAGNUS (8/6/09)
  magnus: {
    title: 'Magnus Eriksson',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
    ]
  },

  # CHRIS S. (9/28/09)
  chris_s: {
    title: 'Chris Sugrue',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
    ]
  },

  # TODD V. (9/28/09)
  # todd_v: {
  #   title: 'Todd Vanderlin',
  #   subtitle: words.sample(3).join(' ').capitalize, 
  #   excerpt: words.sample(20).join(' ').capitalize, 
  #   description: words.sample(100).join(' ').capitalize,
  #   pieces: [
  #   ]
  # },

  # GOLAN (7/22/10)
  golan: {
    title: 'Golan Levin',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
    ]
  },

  # CORY (11/10/10)
  # cory: {
  #   title: 'Cory Archangel',
  #   subtitle: words.sample(3).join(' ').capitalize, 
  #   excerpt: words.sample(20).join(' ').capitalize, 
  #   description: words.sample(100).join(' ').capitalize,
  #   pieces: [
  #   ]
  # },

  # KYLE (3/27/11)
  kyle: {
    title: 'Kyle McDonald',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
      {
        type:  :text,
        title: 'Kyle McDonald',
        content: words.sample(100).join(' ').capitalize,
      },
      {
        type:  :page,
        title: 'Tweet',
        content: words.sample(100).join(' ').capitalize,
        url: 'https://twitter.com/kcimc/status/24677764831',
        timeline_year: '2010',
        events: [
          {type: :popup, array: ['p.tweet-text'], timeout: 5000, text: 'Links to article about T-Mobile trademarking the color magenta, one of the two colors associated with FAT Lab.'}
        ]
      },
      {
        type:  :page,
        title: 'keytweeter',
        content: words.sample(100).join(' ').capitalize,
        url: 'https://twitter.com/keytweeter',
        timeline_year: '2009',
        events: [
          {type: :scroll, array: [0], timeout: 4000},
          {type: :scroll, array: [2000], timeout: 3000},
          {type: :scroll, array: [4000], timeout: 3000},
          {type: :scroll, array: [6000], timeout: 3000}
        ]
      },
    ]
  },

  # HENNESSY (6/8/11)
  hennessy: {
    title: 'Hennessy Youngman',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
    ]
  },

  # KATSU (1/7/12)
  katsu: {
    title: 'KATSU',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
    ]
  },

  # ADDIE (4/23/2012)
  addie: {
    title: 'Addie Wagenknecht',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
      {
        type:  :text,
        title: 'Addie Wagenknecht',
        content: words.sample(100).join(' ').capitalize,
      },
      {
        type:  :page,
        title: 'Lasursaur',
        content: words.sample(100).join(' ').capitalize,
        url: 'http://web.archive.org/web/20120209105231/http://placesiveneverbeen.com/index.php?/systems/lasersaur/',
        timeline_year: '2011'
      },
      {
        type:  :page,
        title: 'Undisclosed Publicity',
        content: words.sample(100).join(' ').capitalize,
        url: 'http://web.archive.org/web/20120215104816/http://placesiveneverbeen.com/index.php?/architectural/undisclosed-publicity/',
        timeline_year: '2011'
      },
    ]
  },

  # LM4K
  lm4k: {
    title: 'LM4K',
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize,
    pieces: [
      # TODO
    ]
  },

}





list.each do |k,v|
  s = Section.create(title: (v[:title] || k), subtitle: (v[:subtitle] || words.sample(3).join(' ').capitalize), excerpt: (v[:excerpt] || words.sample(20).join(' ').capitalize), description: (v[:description] || words.sample(100).join(' ').capitalize))
  @exhibition.sections << s

  v[:pieces].each do |p|
    ep = ExhibitionPiece.create(exhibition: @exhibition)
    case p[:type]
      when :text
        ep.piece = PieceText.create(
          title: (p[:title] || words.sample(10).each(&:capitalize).join(' ')),
          content: (p[:content] || words.sample(500).join(' ').capitalize),
          theme: (p[:theme] || PieceText::THEMES.first)
        )
      when :page
        ep.piece = PiecePage.create(
          title: (p[:title] || words.sample(10).each(&:capitalize).join(' ')),
          url: p[:url],
          timeline_date: p[:date],
          timeline_year: p[:date_year],
          excerpt: (p[:excerpt] || words.sample(20).join(' ').capitalize), 
          description: (p[:description] || words.sample(100).join(' ').capitalize),
          author: (p[:author] || words.sample(2).map(&:capitalize).join(' ')),
          organization: (p[:organization] || words.sample(1).map(&:capitalize).join(' '))
        )
        (p[:events] || []).each do |e|
          pe = PiecePageEvent.create(action_type: PiecePageEvent::TYPES.index(e[:type]), action_array: (e[:array] || []), action_timeout: e[:timeout], action_text: e[:text])
          ep.piece.page_events << pe
        end

      else
        # nothing
    end

    s.exhibition_pieces << ep
  end
end










# @sections, @exhibition_pieces, @page_events = [], [], []
# 
# urls = [
#   'http://gleu.ch/',
#   'http://fffff.at',
#   'http://xolator.com',
#   'http://fromjia.com',
#   'http://eyebeam.org',
#   'http://jamiedubs.com',
#   'http://evan-roth.com'
# ].shuffle
# 
# 
# @exhibition = Exhibition.create(
#   title: words.sample(3).map(&:capitalize).join(' '), 
#   subtitle: words.sample(3).join(' ').capitalize, 
#   excerpt: words.sample(20).join(' ').capitalize, 
#   description: words.sample(100).join(' ').capitalize
# )
# 
# 2.times do |i|
#   section = @exhibition.sections.create(
#     title: (words.sample(2) << i.to_s).map(&:capitalize).join(' '),
#     subtitle: words.sample(3).join(' ').capitalize, 
#     excerpt: words.sample(20).join(' ').capitalize, 
#     description: words.sample(100).join(' ').capitalize
#   )
# 
#   exhibition_piece = ExhibitionPiece.create(exhibition: @exhibition)
#   piece = PieceText.create(
#     title: words.sample(3).map(&:capitalize).join(' '),
#     content: words.sample(500).join(' ').capitalize,
#     theme: PieceText::THEMES.first
#   )
#   # puts piece.errors.inspect
#   exhibition_piece.piece = piece
#   section.exhibition_pieces << exhibition_piece
#   @exhibition_pieces << piece
# 
#   2.times do |j|
#     exhibition_piece = ExhibitionPiece.create(exhibition: @exhibition)
#     piece = PiecePage.create(
#       title: words.sample(3).map(&:capitalize).join(' '),
#       url: urls.pop,
#       timeline_date: Date.today,
#       timeline_year: Date.today.year,
#       excerpt: words.sample(20).join(' ').capitalize, 
#       description: words.sample(100).join(' ').capitalize,
#       author: words.sample(2).map(&:capitalize).join(' '),
#       organization: words.sample(1).map(&:capitalize).join(' ')
#     )
#     (1..2).each do |l|
#       page_event = PiecePageEvent.create(action_type: PiecePageEvent::TYPES.index(:scroll), action_array: [200*l], action_timeout: (1000*2*l))
#       @page_events << page_event
#       piece.page_events << page_event
#     end
# 
#     page_event = PiecePageEvent.create(action_type: PiecePageEvent::TYPES.index(:popup), action_array: ['p:eq(0)'], action_text: words.sample(rand(100)+1).join(' '), action_timeout: 10000)
#     @page_events << page_event
#     piece.page_events << page_event
# 
#     (3..4).each do |l|
#       page_event = PiecePageEvent.create(action_type: PiecePageEvent::TYPES.index(:scroll), action_array: [200*l], action_timeout: (1000*2*l))
#       @page_events << page_event
#       piece.page_events << page_event
#     end
#     exhibition_piece.piece = piece
#     section.exhibition_pieces << exhibition_piece
#     @exhibition_pieces << piece
#   end
# 
#   @sections << section
# end
# 
# 
# puts @exhibition.inspect, @sections.inspect, @exhibition_pieces.inspect, @page_events.inspect
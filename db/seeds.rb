# Start with creating a fake exhibition we can control
# Creation and management section to come later

words = %w(Neutra chillwave literally photo booth High Life mixtape you probably haven't heard of them before they sold out jean shorts cliche mlkshk Letterpress fap DIY iPhone Terry Richardson Keytar literally sartorial Terry Richardson Portland tofu direct trade retro ethical tumblr plaid typewriter gluten-free Plaid Bushwick try-hard cornhole trust fund helvetica McSweeney's 3 wolf moon meggings blue bottle small batch thundercats mlkshk Single-origin coffee letterpress occupy craft beer Schlitz ennui Tonx hoodie vinyl Portland Bushwick Bushwick you probably haven't heard of them umami 3 wolf moon art party messenger bag seitan shoreditch flannel organic hashtag master cleanse raw denim pour-over Biodiesel mumblecore kogi umami chambray fanny pack semiotics kale chips kitsch hashtag synth keffiyeh you probably haven't heard of them raw denim Hella selvage High Life plaid cliche Williamsburg polaroid Banksy narwhal organic literally Vice Butcher pickled VHS cliche bicycle rights fingerstache Banksy locavore dreamcatcher sriracha raw denim Kogi irony lo-fi bitters pitchfork skateboard gluten-free sustainable hella chillwave ethnic squid post-ironic typewriter Actually letterpress scenester pork belly semiotics pour-over shoreditch food truck art party Terry Richardson tumblr viral Pinterest banh mi cliche mumblecore tofu hoodie Tonx Skateboard gentrify fashion axe you probably haven't heard of them retro food truck banh mi 3 wolf moon gluten-free DIY Brooklyn locavore authentic lomo Pickled next level shoreditch aesthetic you probably haven't heard of them PBR umami small batch Ugh synth chillwave sustainable gastropub Flannel Banksy keffiyeh Wes Anderson ugh High Life put a bird on it hoodie 8-bit whatever tattooed stumptown Schlitz Kogi tote bag pug Cosby sweater forage asymmetrical four loko master cleanse post-ironic bicycle rights narwhal scenester letterpress 3 wolf moon put a bird on it PBR tumblr fanny pack lo-fi Echo Park pork belly actually ethical fixie semiotics pop-up gastropub mlkshk American apparel pitchfork whatever narwhal wayfarers craft beer Portland ennui authentic Terry Richardson tote bag four loko forage Williamsburg helvetica literally Mixtape ethical seitan ennui Try-hard vinyl asymmetrical Wes Anderson 8-bit flexitarian forage twee Neutra Blog craft beer Carles tumblr Flexitarian locavore cred wolf typewriter Lo-fi tousled church-key locavore master cleanse food truck narwhal letterpress authentic gastropub artisan Flannel gastropub vinyl 8-bit raw denim Odd Future gluten-free Schlitz shabby chic kogi small batch sriracha art party sustainable master cleanse Irony pork belly Pinterest single-origin coffee keytar polaroid shabby chic tousled Vice Bushwick cray hoodie fingerstache Etsy Salvia fap Bushwick Wes Anderson)

[Exhibition, ExhibitionPiece, PieceText, PiecePage, PieceThumbnail, Section, ExhibitionUser].each do |m|
  m.all(&:destroy)
end


@sections, @exhibition_pieces, @page_events = [], [], []

urls = [
  'http://gleu.ch/',
  'http://fffff.at',
  'http://xolator.com',
  'http://fromjia.com',
  'http://eyebeam.org',
  'http://jamiedubs.com',
  'http://evan-roth.com'
].shuffle


@exhibition = Exhibition.create(
  title: words.sample(3).map(&:capitalize).join(' '), 
  subtitle: words.sample(3).join(' ').capitalize, 
  excerpt: words.sample(20).join(' ').capitalize, 
  description: words.sample(100).join(' ').capitalize
)

2.times do |i|
  section = @exhibition.sections.create(
    title: (words.sample(2) << i.to_s).map(&:capitalize).join(' '),
    subtitle: words.sample(3).join(' ').capitalize, 
    excerpt: words.sample(20).join(' ').capitalize, 
    description: words.sample(100).join(' ').capitalize
  )

  exhibition_piece = ExhibitionPiece.create(exhibition: @exhibition)
  piece = PieceText.create(
    title: words.sample(3).map(&:capitalize).join(' '),
    content: words.sample(500).join(' ').capitalize,
    theme: PieceText::THEMES.first
  )
  # puts piece.errors.inspect
  exhibition_piece.piece = piece
  section.exhibition_pieces << exhibition_piece
  @exhibition_pieces << piece

  2.times do |j|
    exhibition_piece = ExhibitionPiece.create(exhibition: @exhibition)
    piece = PiecePage.create(
      title: words.sample(3).map(&:capitalize).join(' '),
      url: urls.pop,
      timeline_date: Date.today,
      timeline_year: Date.today.year,
      excerpt: words.sample(20).join(' ').capitalize, 
      description: words.sample(100).join(' ').capitalize,
      author: words.sample(2).map(&:capitalize).join(' '),
      organization: words.sample(1).map(&:capitalize).join(' ')
    )
    page_event = PiecePageEvent.create(action_type: PiecePageEvent::TYPES.index(:scroll), action_array: [200])
    @page_events << page_event
    piece.page_events << page_event
    exhibition_piece.piece = piece
    section.exhibition_pieces << exhibition_piece
    @exhibition_pieces << piece
  end

  @sections << section
end


puts @exhibition.inspect, @sections.inspect, @exhibition_pieces.inspect, @page_events.inspect
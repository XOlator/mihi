# Start with creating a fake exhibition we can control
# Creation and management section to come later


@sections, @exhibition_pieces = [], []


@exhibition = Exhibition.create(
  title: "Exhibition Name", 
  subtitle: "Some tagline", 
  excerpt: "This is the exhibition excerpt.", 
  description: "This is the description for a exhibition."
)

2.times do |i|
  section = @exhibition.sections.create(
    title: "Section #{i}", 
    subtitle: "Section Subtitle", 
    excerpt: "This is the section excerpt.", 
    description: "This is the description for a section."
  )

  exhibition_piece = ExhibitionPiece.create
  piece = PieceText.create(
    title: "Piece Text",
    content: "This would be really long content",
    theme: PieceText::THEMES.first
  )
  # puts piece.errors.inspect
  exhibition_piece.piece = piece
  section.exhibition_pieces << exhibition_piece
  @exhibition_pieces << piece

  2.times do |j|
    exhibition_piece = ExhibitionPiece.create
    piece = PiecePage.create(
      title: "Piece Text #{j}",
      url: "http://gleu.ch/project/#{i}-#{j}",
      description: "This would be really long content",
      timeline_date: Date.today,
      timeline_year: Date.today.year,
      excerpt: "This is the piece excerpt.", 
      description: "This is the description for a pieces.",
      author: "Greg Leuch",
      organization: "X&O"
    )
    exhibition_piece.piece = piece
    section.exhibition_pieces << exhibition_piece
    @exhibition_pieces << piece
  end

  @sections << section
end


puts @exhibition.inspect, @sections.inspect, @exhibition_pieces.inspect
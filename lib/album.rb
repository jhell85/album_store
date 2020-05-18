require 'pry'

class Album

 
  attr_accessor :id, :name, :artist, :genre, :year, :in_inventory

  # form
  # @@albums = {}
  # @@total_rows = 0 # We've added a class variable to keep track of total rows and increment the value when an ALbum is added.
  # @@sold_albums = {}

  # def initialize(name, id, artist, genre, year)
  #   @name = name
  #   @id = id || @@total_rows += 1  # We've added code to handle the id.
  #   @artist = artist 
  #   @genre = genre 
  #   @year = year
  #   @in_inventory = true
  # end

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
    @artist = attributes.fetch(:artist)
    @genre = attributes.fetch(:genre)
    @year = attributes.fetch(:year)
    # @in_inventory = true
  end

  def self.all
    returned_albums = DB.exec("SELECT * FROM albums;")
    albums = []
    returned_albums.each() do |album|
      name = album.fetch("name")
      id = album.fetch("id").to_i
      artist = album.fetch("artist")
      genre = album.fetch("genre")
      year = album.fetch("year").to_i
      albums.push(Album.new({name: name, id: id, artist: artist, genre: genre, year: year}))
    end
    albums
  end

  # def self.all_sold
  #   @@sold_albums.values()
  # end

  def save
    result = DB.exec("INSERT INTO albums (name, artist, genre, year) VALUES ('#{@name}', '#{@artist}', '#{@genre}', '#{@year}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(album_to_compare)
    self.name() == album_to_compare.name()
  end

  def self.clear
    DB.exec("DELETE FROM albums *;")
  end

  def self.find(id)
    album = DB.exec("SELECT * FROM albums WHERE id = #{id};").first
    name = album.fetch("name")
    id = album.fetch("id").to_i
    artist = album.fetch("artist")
    genre = album.fetch("genre")
    year = album.fetch("year").to_i
    Album.new({ name: name, id: id, artist: artist, genre: genre, year: year})
  end

  def update(name)
   @name = name
   DB.exec("UPDATE albums SET name = '#{@name}' WHERE ID = #{@id};")
  end

  def delete
    DB.exec("DELETE FROM albums WHERE id = #{@id};")
  end

  def self.search(name)
    album_names = Album.all.map {|a| a.name }
    result = []
    names = album_names.grep(/#{name}/)
    names.each do |n| 
      display_albums = Album.all.select {|a| a.name == n}
      result.concat(display_albums)
    end
    result
  end

  def self.sort()
    # record_list = @@albums.values
    albums = self.all
    sorted_records = albums.sort_by{ |record| record.name }
    sorted_records
  end
 
  def sold()
    self.in_inventory = false
    @@albums[self.id] = self
    # @@sold_albums[self.id] = Album.new(self.name, self.id, self.artist, self.genre, self.year)
  end

  def songs
    Song.find_by_album(self.id)
  end
end
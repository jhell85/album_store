require('sinatra')
require('sinatra/reloader')
require('./lib/album')
require('./lib/song')
require('pry')
also_reload('lib/**/*.rb')

get('/') do
  @albums = Album.sort
  erb(:albums) #erb file name
end

get('/albums') do
  @albums = Album.sort
  erb(:albums)
end

get('/albums/new') do
  erb(:new_album)
end

get('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  erb(:album)
end

get('/albums/search/results') do
  @albums = Album.search(params[:search])
  erb(:search_results)
end

post('/albums') do ## Adds album to list of albums, cannot access in URL bar
  name = params[:album_name]
  artist = params[:album_artist]
  year = params[:album_year]
  genre = params[:album_genre]
  song = params[:song_id]
  in_inventory = params[:in_inventory]
  album = Album.new({:name => name, :id => nil, :artist => artist, :genre => genre, :year => year})
  album.save()
  redirect to('/albums')
end

# get('/albums/:id/sort') do
#   @album = Album.find(params[:id].to_i())
#   erb(:albums)
# end

get('/albums/:id/buy') do
  @album = Album.find(params[:id].to_i())
  erb(:buy_album)
end

get('/albums/:id/edit') do
  @album = Album.find(params[:id].to_i())
  erb(:edit_album)
end

patch('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @albums = Album.all
  if params[:buy]
    @album.sold()
  else  
    @album.update(params[:name])
  end
  erb(:albums)
end

delete('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.delete()
  redirect to('/albums')
end

# get('/custom_route') do
#   "We can even create custom routes, but we should only do this when needed."
# end

# Get the detail for a specific song such as lyrics and songwriters.
get('/albums/:id/songs/:song_id') do
  @song = Song.find(params[:song_id].to_i())
  erb(:song)
end

# Post a new song. After the song is added, Sinatra will route to the view for the album the song belongs to.
post('/albums/:id/songs') do
  @album = Album.find(params[:id].to_i())
  song = Song.new(params[:song_name], @album.id, nil)
  song.save()
  erb(:album)
end

# Edit a song and then route back to the album view.
patch('/albums/:id/songs/:song_id') do
  @album = Album.find(params[:id].to_i())
  song = Song.find(params[:song_id].to_i())
  song.update(params[:name], @album.id)
  erb(:album)
end

# Delete a song and then route back to the album view.
delete('/albums/:id/songs/:song_id') do
  song = Song.find(params[:song_id].to_i())
  song.delete
  @album = Album.find(params[:id].to_i())
  erb(:album)
end
## implement sold() method on album.erb
## implement sort method on albums.erb
## implement search method on albums.erb
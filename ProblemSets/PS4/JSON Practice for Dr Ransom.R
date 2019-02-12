system("linux shell command")
nfl.json <- system("wget -O 'http://api.fantasy.nfl.com/v1/players/stats?statType=seasonStats&season=2010&week=1&format=json' ")
nfl.json
install.packages("jsonlite")
library(jsonlite)
nfl.json
mydf <- fromJSON('nfl.json')
class(nfl.json)
class(mydf$players)
head(mydf)

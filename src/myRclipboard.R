# To get run numbers for panicum halli
# Copy bioprojects from table S1 in this publication: https://doi.org/10.1038/s41467-018-07669-x
# to a list in doc/panicum_halli_search.txt
# then use regular expressions to make a query to be used with ENTREZ
# cat panicum_halli_search.txt | tr '\n' ' ' | sed 's/ / OR /g'
# esearch -db sra -query $QUERY | efetch --format runinfo > panicum_halli.csv

#
7221300

#
5832702

#
2803330

#
3040983

#
2878373

#
5293186

#
2703464

#
3625538

#
5357027

#
3140467

#
Rscript scripts/download_gbif.R glycine_soja $GBIF_USER $GBIF_EMAIL $GBIF_PWD 20 200 5359668

#
3152663

#
2876032

#
3625134

#
3083905


#
2960284


#
5582578

#
8089775

#
5289974

#
3623807

#
8105068

#
3590844

#
3042809

#
3042837





2982409
#
5529117

#
3171159

#
4097481
4097481

#
3799678

#
2930642 8402242

#
7901873 2931761

#
5289684

#
7266664

#
4174687

#
4174017

#
6362904

#
3040232

#
5356701

#
2888443

#
2705116

#
9167736

#
2703462

#
4940610 11365001 5942013

#
4110272

#
2703457

#
7506783

#
7503234


#
2762950

#
3042551

#
3042624

#
5290146

# SE that should actually be PE
SRR1261957
SRR1250413
SRR1261704
SRR1261701
SRR1261610

#
7346090

#
2965201

#

3060733

#
3190640

#
3001509

#
3001162

#
2964374

#
5350011

#

7267415

#
3119206

#

7994689

#


ERR636156

#
2705953

#
8791596

#
4073136

#
2755063

#
2874513

#
2895430

#
5375425

#
5375387

#
3173337

# brachypodium distachyon
5290143

# Arabidopsis lyrata bioprojects
PRJNA357693
PRJEB30473

#
SraRunInfo_arabidopsis_lyrata_PRJEB23202.csv.gz
SraRunInfo_arabidopsis_lyrata_PRJEB30473.csv.gz
SraRunInfo_arabidopsis_lyrata_PRJNA284572.csv.gz

#
#obtain data from GBIF via rgbif
dat <- occ_search(scientificName = "Panthera leo", limit = 5000, hasCoordinate = T)

dat <- dat$data

# names(dat) #a lot of columns

#select columns of interest
dat <- dat %>%
  dplyr::select(species, decimalLongitude, decimalLatitude, countryCode, individualCount,
         gbifID, family, taxonRank, coordinateUncertaintyInMeters, year,
         basisOfRecord, institutionCode, datasetName)
         
#plot data to get an overview
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = dat, aes(x = decimalLongitude, y = decimalLatitude),
             colour = "darkred", size = 0.5)+
  theme_bw()

# https://github.com/vsbuffalo/paradox_variation/blob/master/R/range_funcs.r
# get continent from coordinates  
countriesSP <- rworldmap:::getMap(resolution='low')
coords2continent = function(lat, lon) {  
  # https://stackoverflow.com/questions/21708488/get-country-and-continent-from-longitude-and-latitude-point-in-r
  points <- data.frame(lon=lon, lat=lat)
  # converting points to a SpatialPoints object
  # setting CRS directly to that from rworldmap
  pointsSP = sp:::SpatialPoints(points, proj4string=sp:::CRS(sp:::proj4string(countriesSP)))  

  # use 'over' to get indices of the Polygons object containing each point 
  indices = sp:::over(pointsSP, countriesSP)

  #indices$REGION   # returns the continent (7 continent model)
  indices$continent
}

#
y = spTransform(x, CRS("+proj=longlat +datum=WGS84"))

# draw convex hulls
# "proj.4" notation of CRS
projection(cn) <- "+proj=longlat +datum=WGS84"
# the CRS we want
laea <- CRS("+proj=laea  +lat_0=0 +lon_0=-80")
clb <- spTransform(cn, laea)
pts <- spTransform(sp, laea)
plot(clb, axes=TRUE)
points(pts, col='red', cex=.5)
# get the (Lambert AEA) coordinates from the SpatialPointsDataFrame
xy <- coordinates(pts)
# draw convex hulls on projected points
hull <- list()
for (s in 1:length(sp)) {
    p <- unique(xy[pts$SPECIES == sp[s], ,drop=FALSE])
    # need at least three points for hull
    if (nrow(p) > 3) {
        h <- convHull(p, lonlat=FALSE)
        pol <- polygons(h)
        hull[[s]] <- pol
    }
}
# combine hulls
# which elements are NULL
i <- which(!sapply(hull, is.null))
h <- hull[i]
# combine them
hh <- do.call(bind, h)
plot(hh)
# calculate area of hulls
ahull <- sapply(hull, function(i) ifelse(is.null(i), 0, area(i)))
plot(rev(sort(ahull))/1000, ylab='Area of convex hull')





# https://babichmorrowc.github.io/post/2019-03-18-alpha-hull/
ashape2poly <- function(ashape){
  # Convert node numbers into characters
  ashape$edges[,1] <- as.character(ashape$edges[,1])
  ashape_graph <- graph_from_edgelist(ashape$edges[,1:2], directed = FALSE)
  if (!is.connected(ashape_graph)) {
    stop("Graph not connected")
  }
  if (any(degree(ashape_graph) != 2)) {
    stop("Graph not circular")
  }
  if (clusters(ashape_graph)$no > 1) {
    stop("Graph composed of more than one circle")
  }
  # Delete one edge to create a chain
  cut_graph <- ashape_graph - E(ashape_graph)[1]
  # Find chain end points
  ends = names(which(degree(cut_graph) == 1))
  path = get.shortest.paths(cut_graph, ends[1], ends[2])$vpath[[1]]
  # this is an index into the points
  pathX = as.numeric(V(ashape_graph)[path]$name)
  # join the ends
  pathX = c(pathX, pathX[1])
  return(pathX)
}


#
"Amaranthus hypochondriacus",
"Amaranthus tuberculatus",
"Amborella trichopoda",
"Ananas comosus",
"Aquilegia coerulea",
"Arabidopsis halleri",
"Arabidopsis lyrata",
"Arabidopsis thaliana",
"Arachis hypogaea",
"Asparagus officinalis",
"Beta vulgaris",
"Betula platyphylla",
"Boechera stricta",
"Brachypodium distachyon",
"Brachypodium hybridum",
"Brachypodium stacei",
"Brassica oleracea capitata",
"Brassica rapa",
"Capsella grandiflora",
"Capsella orientalis",
"Capsella rubella",
"Carica papaya",
"Carya illinoinensis",
"Chenopodium quinoa",
"Cicer arietinum",
"Cinnamomum kanehirae",
"Citrullus lanatus",
"Citrus clementina",
"Citrus sinensis",
"Corymbia citriodora",
"Cucumis sativus",
"Daucus carota",
"Dioscorea alata",
"Diphasiastrum complanatum",
"Eucalyptus grandis",
"Eutrema salsugineum",
"Fragaria vesca",
"Fragaria x ananassa",
"Glycine max",
"Glycine soja",
"Gossypium barbadense",
"Gossypium darwinii",
"Gossypium hirsutum",
"Gossypium mustelinum",
"Gossypium raimondii",
"Gossypium tomentosum",
"Helianthus annuus",
"Hordeum vulgare",
"Kalanchoe fedtschenkoi",
"Lactuca sativa",
"Lens culinaris",
"Lens ervoides",
"Linum usitatissimum",
"Liriodendron tulipifera",
"Lotus japonicus",
"Lupinus albus",
"Manihot esculenta",
"Medicago truncatula",
"Mimulus guttatus",
"Miscanthus sinensis",
"Musa acuminata",
"Nymphaea colorata",
"Olea europaea",
"Oropetium thomaeum",
"Oryza sativa",
"Panicum hallii",
"Panicum virgatum",
"Phaseolus acutifolius",
"Phaseolus vulgaris",
"Poncirus trifoliata",
"Populus trichocarpa",
"Prunus persica",
"Ricinus communis",
"Salix purpurea",
"Schrenkiella parvula",
"Setaria italica",
"Setaria viridis",
"Solanum lycopersicum",
"Solanum tuberosum",
"Sorghum bicolor",
"Spinacia oleracea",
"Spirodela polyrhiza",
"Theobroma cacao",
"Thinopyrum intermedium",
"Trifolium pratense",
"Triticum aestivum",
"Triticum turgidum",
"Vaccinium darrowii",
"Vigna unguiculata",
"Vitis vinifera",
"Zea mays",
"Zostera marina",
"Arabis alpina",
"Actinidia chinensis",
"Aegilops tauschii",
"Brassica juncea",
"Brassica napus",
"Secale cereale",
"Camelina sativa",
"Cannabis sativa",
"Capsicum annuum",
"Chara braunii",
"Chlamydomonas reinhardtii",
"Chondrus crispus",
"Coffea canephora",
"Corchorus capsularis",
"Corylus avellana",
"Corymbia citriodora",
"Cucumis melo",
"Cyanidioschyzon merolae",
"Cynara cardunculus",
"Digitaria exilis",
"Dioscorea rotundata",
"Echinochloa crus-galli",
"Eragrostis curvula",
"Eragrostis tef",
"Ficus carica",
"Galdieria sulphuraria",
"Ipomoea triloba",
"Juglans regia",
"Leersia perrieri",
"Lolium perenne",
"Lupinus angustifolius",
"Marchantia polymorpha",
"Nicotiana attenuata",
"Oryza barthii",
"Oryza brachyantha",
"Oryza glaberrima",
"Oryza glumipatula",
"Oryza longistaminata",
"Oryza meridionalis",
"Oryza nivara",
"Oryza punctata",
"Oryza rufipogon",
"Ostreococcus lucimarinus",
"Papaver somniferum",
"Physcomitrium patens",
"Pistacia vera",
"Pisum sativum",
"Prunus avium",
"Prunus dulcis",
"Quercus lobata",
"Quercus suber",
"Rosa chinensis",
"Saccharum spontaneum",
"Selaginella moellendorffii",
"Sesamum indicum",
"Triticum dicoccoides",
"Triticum spelta",
"Triticum urartu",
"Vigna angularis",
"Vigna radiata",
"Vigna unguiculata",
"Picea abies",
"Phoenix dactylifera",


###
Abrus precatorius
Actinidia rufa
Adiantum capillus-veneris
Adiantum nelumboides
Arabidopsis suecica
Arabis nemorensis
Arachis duranensis
Arachis ipaensis
Aristolochia fimbriata
Bauhinia variegata
Benincasa hispida
Brassica carinata
Brassica oleracea
Buddleja alternifolia
Cajanus cajan
Camellia sinensis
Carex littledalei
Castanea mollissima
Ceratodon purpureus
Ceratopteris richardii
Coffea arabica
Coffea eugenioides
Coptis chinensis
Cucurbita argyrosperma
Cucurbita maxima
Cucurbita moschata
Cucurbita pepo
Cuscuta campestris
Cuscuta epithymum
Cuscuta europaea
Dendrobium chrysotoxum
Dendrobium nobile
Dioscorea cayenensis
Diospyros lotus
Durio zibethinus
Elaeis guineensis
Eleusine coracana
Ensete ventricosum
Erigeron canadensis
Genlisea aurea
Gossypium anomalum
Gossypium arboreum
Gossypium aridum
Gossypium armourianum
Gossypium davidsonii
Gossypium gossypioides
Gossypium harknessii
Gossypium klotzschianum
Gossypium laxum
Gossypium lobatum
Gossypium schwendimanii
Gossypium stocksii
Gossypium trilobum
Heliosperma pusillum
Herrania umbratica
Hevea brasiliensis
Impatiens glandulifera
Jatropha curcas
Kingdonia uniflora
Lithospermum erythrorhizon
Lolium rigidum
Macadamia integrifolia
Malus domestica
Malus sylvestris
Mangifera indica
Marchantia paleacea
Melastoma candidum
Microthlaspi erraticum
Miscanthus lutarioriparius
Momordica charantia
Morus notabilis
Musa troglodytarum
Nelumbo nucifera
Nymphaea thermarum
Papaver armeniacum
Papaver atlanticum
Papaver bracteatum
Papaver californicum
Paulownia fortunei
Perilla frutescens
Phtheirospermum japonicum
Populus deltoides
Populus tomentosa
Potentilla anserina
Prosopis alba
Prunus armeniaca
Psidium guajava
Punica granatum
Quercus robur
Rhodamnia argentea
Rhododendron griersonianum
Rhododendron simsii
Salix dunnii
Salix suchowensis
Salvia hispanica
Salvia splendens
Senna tora
Shorea leprosula
Sinapis alba
Solanum commersonii
Solanum pennellii
Solanum stenotomum
Spirodela intermedia
Striga hermonthica
Tarenaya hassleriana
Taxus chinensis
Telopea speciosissima
Tetracentron sinense
Thalictrum thalictroides
Thlaspi arvense
Tripterygium wilfordii
Vanilla planifolia
Vigna umbellata
Vitis riparia
Xanthoceras sorbifolium
Zingiber officinale
Zizania palustris
Ziziphus jujuba

# 12 species with the fewest samples
arachis_duranensis            camelina_sativa          nicotiana_tabacum           arachis_ipaensis 
brassica_nigra             cucurbita_pepo          arabis_nemorensis             oryza_punctata 
arabidopsis_suecica         solanum_stenotomum               ficus_carica          solanum_melongena 

#
ott_in_tree <- ott_id(taxon_search)[is_in_tree(ott_id(taxon_search))]
tr <- tol_induced_subtree(ott_ids = ott_in_tree)

tr$tip.label <- strip_ott_ids(tr$tip.label, remove_underscores = TRUE)

#
"Arabidopsis suecica" 
"Arabis nemorensis"   
"Arachis hypogaea"    
"Arachis ipaensis"    
"Camelina sativa"    
"Ficus carica"        
"Nicotiana tabacum"   
"Oryza punctata"

# Arachis glabrata
5353813


# Actinidia polygama
3189692 7379759 7620678 7879124

#
5353784


# Actinidia callosa
7270822


#
7915981 3052544

# Actinidia eriantha
3644693 7270743 3644698 3644711

# Aegilops tauschii
5289779 5677746 5677750 7226877 5677755 5677762 5677759 5677753

# Amaranthus hybridus
5384364 7554918 8111324 7442708 10145116 10538632 10634896 10279930 5547885 7867601

# Ananas comosus var. microstachys
5288770

# Arabidopsis halleri
3052450 9403166 3052459 11097917 3689665 7225571 10906894 3052455 10999708 10940826

# Arabidopsis lyrata
3052468 3052469 3052478 7225570 9372560

# Arabidopsis thaliana
3052436 7758053 3052446

# Beta vulgaris
8372932 7657202

# Arabis alpina
5375020 5374885 8576900 9044273 7694599 8349130 5375026 5551157 7785553 9614998

# Arabis nemorensis
8288982 5374937 5552336 7292834 5374934

# Arachis stenosperma
5353758

# Arachis duranensis
5353841

# Arachis ipaensis
5353793

# Benincasa pruriens
3623456 7317644 2874524 3623445 3623491 8312084 2874525 7317643

# Boechera stricta
3043392

# Camelina sativa
3042439 7528991 3042443 3042441 3689020 3042425 3042427 3042396

# Nicotiana sylvestris
2928767

# Brassica nigra
3042658 8010384 7509066 3042673 3692032 3042665 7437326 6306670 7844947

# Oryza punctata
2703461 8663541 11356139 5941998

# Solanum stenotomum
3799678 9673874 4937418

# Ficus erecta
5571945 6135850 7616056 9534337 7433549 5834128 8126416 7581614 11354470 11283465

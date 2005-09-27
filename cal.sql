BEGIN TRANSACTION;
create table events (
date VARCHAR(10),
description TEXT
);
INSERT INTO events VALUES('2003-02-05','something or other');
INSERT INTO events VALUES('2003-02-05','foo bar');
INSERT INTO events VALUES('2003-02-06','quirka');
INSERT INTO events VALUES('2003-02-05','funky');
INSERT INTO events VALUES('2003-03-06','london.pm');
INSERT INTO events VALUES('2003-03-10','celia -> French');
INSERT INTO events VALUES('2003-02-12','Celia meeting up with Nikki');
INSERT INTO events VALUES('2003-02-10','Celia -> French class');
INSERT INTO events VALUES('2003-02-09','Alex''s bowling birthday');
INSERT INTO events VALUES('2003-02-08','Olof''s party');
INSERT INTO events VALUES('2003-02-08','sum41');
INSERT INTO events VALUES('2003-02-07','mattb''s birthday drinks');
INSERT INTO events VALUES('2003-02-16','roast dinner at 2lmc');
INSERT INTO events VALUES('2003-03-21','ASIST conference');
INSERT INTO events VALUES('2003-03-22','ASIST conference');
INSERT INTO events VALUES('2003-03-23','ASIST conference');
INSERT INTO events VALUES('2003-02-15','England vs France 4pm');
INSERT INTO events VALUES('2003-02-12','Simon meeting Ash');
INSERT INTO events VALUES('2003-02-10','Simon to Mark E');
INSERT INTO events VALUES('2003-02-11','Simon to Jen');
INSERT INTO events VALUES('2003-02-18','Ben back, drinky pinkies');
INSERT INTO events VALUES('2003-02-17','Celia->french');
INSERT INTO events VALUES('2003-02-24','Celia->french');
INSERT INTO events VALUES('2003-04-08','Matthew Good Band playing london');
INSERT INTO events VALUES('2003-02-14','Valentines Day');
INSERT INTO events VALUES('2003-02-20','Fi round for food and BeMani games');
INSERT INTO events VALUES('2003-03-06','Miriam''s birthday');
INSERT INTO events VALUES('2003-02-19','Orange Boom Boom at De Hems');
INSERT INTO events VALUES('2003-03-03','Celia->French');
INSERT INTO events VALUES('2003-03-17','Celia->French');
INSERT INTO events VALUES('2003-04-01','Simon''s Dad''s birthday');
INSERT INTO events VALUES('2003-02-26','Celia meeting up with Nikki');
INSERT INTO events VALUES('2003-02-21','Simon -> Martin');
INSERT INTO events VALUES('2003-03-14','Metrius drinks');
INSERT INTO events VALUES('2003-02-26','Leon''s birthday drinks, Grand Central, Old Street');
INSERT INTO events VALUES('2003-03-04','Mark''s birthday drinks at the Albion');
INSERT INTO events VALUES('2003-02-25','Natasha is reading at Public LIfe, 7-12pm');
INSERT INTO events VALUES('2003-03-28','Grant Morrison at the ICA');
INSERT INTO events VALUES('2003-02-22','Go and see Ange, Tomo and Maya');
INSERT INTO events VALUES('2003-02-23','possible ''the hours'' viewing, 6.45');
INSERT INTO events VALUES('2003-02-23','Go to see MayaAngeandTomo, 2pm');
INSERT INTO events VALUES('2003-02-23','Dog walking, Hampstead Heath');
INSERT INTO events VALUES('2003-02-27','Elbow room?');
INSERT INTO events VALUES('2003-03-05','Dinner at Gaylord with Greg');
INSERT INTO events VALUES('2003-02-28','Tapas with Mike, Rhi, Mark, Julie');
INSERT INTO events VALUES('2003-03-12','Simon to speak at [AIGA|http://www.experiencedesign.aiga.org/content.cfm?ContentAlias=edlondon]');
INSERT INTO events VALUES('2003-04-12','Simon B and Paul''s birthday party @ 2lmc');
INSERT INTO events VALUES('2003-03-14','XML Europe paper deadline');
INSERT INTO events VALUES('2003-03-03','Have XML Europe paper written');
INSERT INTO events VALUES('2003-03-08','James Dunkley Birthday');
INSERT INTO events VALUES('2003-03-02','Pancakes at JoG');
INSERT INTO events VALUES('2003-03-18','london - ia tech meet');
INSERT INTO events VALUES('2003-03-13','london.pm tech meet ');
INSERT INTO events VALUES('2003-03-07','Drink with Fi, Drapers');
INSERT INTO events VALUES('2003-03-31','Simon -> Dave Turner at The Head of Steam, Euston');
INSERT INTO events VALUES('2003-03-20','We fly out to Portland, a.m.');
INSERT INTO events VALUES('2003-03-29','Both back. ');
INSERT INTO events VALUES('2003-03-10','Aggie''s birthday drinks, Fountains Abbey, Praed St');
INSERT INTO events VALUES('2003-03-09','Rugby at Mark Fowler''s, game starts at 2pm');
INSERT INTO events VALUES('2003-04-05','Velvet''s party - RSVP if going');
INSERT INTO events VALUES('2003-03-14','IA Summit .ppt due');
INSERT INTO events VALUES('2003-04-05','Kay and Martin visiting London');
INSERT INTO events VALUES('2003-04-06','Kay and Martin visiting London');
INSERT INTO events VALUES('2003-04-04','Kay and Martin visiting London');
INSERT INTO events VALUES('2003-03-18','Candace over from the states. (void) [meet|http://www.8bitrecs.com/notclickable3.shtml] up');
INSERT INTO events VALUES('2003-03-11','Send Mark .ppt');
INSERT INTO events VALUES('2003-03-15','Adam and Billy''s birthday at [The Rose and Crown|http://grault.net/cgi-bin/grubstreet.pl?The_Rose_And_Crown,_W5_4QA ] and then the [New Inn|http://grault.net/cgi-bin/grubstreet.pl?The_New_Inn,_W5_4QA] and many others');
INSERT INTO events VALUES('2003-03-17','Timmy coming down');
INSERT INTO events VALUES('2003-04-05','London Eye at 6:30pm ');
INSERT INTO events VALUES('2003-03-24','Simon to Sunnyvale');
INSERT INTO events VALUES('2003-03-24','Celia to NY');
INSERT INTO events VALUES('2003-03-30','Mother''s Day');
INSERT INTO events VALUES('2003-03-19','Drinks at Drapers, not too late');
INSERT INTO events VALUES('2003-04-04','Sofa arrives (8-12am)');
INSERT INTO events VALUES('2003-05-10','Party @ Alice Whitley');
INSERT INTO events VALUES('2003-04-02','(celia) Drinks with Cleg');
INSERT INTO events VALUES('2003-04-16','Meeting up with Monica Chong');
INSERT INTO events VALUES('2003-04-10','celia -> mike p and andrew wood');
INSERT INTO events VALUES('2003-04-08','SimonB''s birthday at the Albion');
INSERT INTO events VALUES('2003-04-09','Simon -> Drapers with the lads');
INSERT INTO events VALUES('2003-04-07','Simon B''s friend''s art thing');
INSERT INTO events VALUES('2003-04-14','celia -> doctor''s appointment, 8.40am.');
INSERT INTO events VALUES('2003-05-23','Dandy Warhols at Brixton Academy');
INSERT INTO events VALUES('2003-04-11','Claire Rowland''s leaving drinks at the Polish Bar.');
INSERT INTO events VALUES('2003-04-15','meet up with Nina');
INSERT INTO events VALUES('2003-07-01','(celia) - tekka article due');
INSERT INTO events VALUES('2003-06-01','Celia - have tekka article written');
INSERT INTO events VALUES('2003-04-14','Templates tech meet @ Yahoo!');
INSERT INTO events VALUES('2003-05-01','Heretics meeting');
INSERT INTO events VALUES('2003-04-14','Celia typography geeking');
INSERT INTO events VALUES('2003-04-12','10.30-11am, sofa move attempt, part 3');
INSERT INTO events VALUES('2003-04-17','Simon -> Max');
INSERT INTO events VALUES('2003-04-16','Profero thing');
INSERT INTO events VALUES('2003-04-28','Sofa collection - (12-8pm)');
INSERT INTO events VALUES('2003-04-22','Celia -> maire and sandra');
INSERT INTO events VALUES('2003-05-03','Deathboy gig in Camden');
INSERT INTO events VALUES('2003-05-01','Celia -> Gayle');
INSERT INTO events VALUES('2003-04-17','Paul Mison''s birthday');
INSERT INTO events VALUES('2003-04-26','Jonah down');
INSERT INTO events VALUES('2003-04-27','Jonah down');
INSERT INTO events VALUES('2003-04-25','LTOTM  @ [Porters Bar|http://www.porters-bar.com/], Soho');
INSERT INTO events VALUES('2003-04-29','Celia -> meet up with Cat ');
INSERT INTO events VALUES('2003-04-25','XML Europe slides due');
INSERT INTO events VALUES('2003-05-07','Celia speaking at XML Europe, 9am');
INSERT INTO events VALUES('2003-05-02','Jenny''s birthday at The Ark, City Road, Angel');
INSERT INTO events VALUES('2003-04-28','Celia -> Nina');
INSERT INTO events VALUES('2003-05-04','Helen''s birthday, Primrose Hill');
INSERT INTO events VALUES('2003-04-30','Celia, pre-dinner drink with Fi');
INSERT INTO events VALUES('2003-05-08','metrius meetup');
INSERT INTO events VALUES('2003-05-05','XML Europe Speaker''s reception');
INSERT INTO events VALUES('2003-05-26','Gareth''s birthday thing');
INSERT INTO events VALUES('2003-05-14','Celia -> Jenny');
INSERT INTO events VALUES('2003-05-09','Celia -> Fiona');
INSERT INTO events VALUES('2003-05-21','Matrix at Warner Village N1, 8.20pm');
INSERT INTO events VALUES('2003-06-03','Celia -> San Francisco');
INSERT INTO events VALUES('2003-06-09','Celia back from San Francisco');
INSERT INTO events VALUES('2003-06-12','Celia meeting Mills for beer');
INSERT INTO events VALUES('2003-05-25','Paddy over');
INSERT INTO events VALUES('2003-06-09','Paddy back to the states');
INSERT INTO events VALUES('2003-05-22','Tech meeting at State 51');
INSERT INTO events VALUES('2003-05-29','Fi and Helen''s for dinner');
INSERT INTO events VALUES('2003-05-23','Celia -> Fi');
INSERT INTO events VALUES('2003-07-05','Fi and Ange birthday thing');
INSERT INTO events VALUES('2003-06-14','[JagFest|http://www.1632systems.co.uk/html%20pages/Shows/Jagfest.htm] UK');
INSERT INTO events VALUES('2003-05-27','Simon to go to [doctors|http://www.nhs.uk/localnhsservices/gp/return_gp_surgery.asp?pid=5K8*F83031&sid=5K8*N1%201BS^1] at 5:20pm');
INSERT INTO events VALUES('2003-06-13','Celia - have tekka.net article written');
INSERT INTO events VALUES('2003-07-12','Hampton Court Palace flower show (we have tickets)');
INSERT INTO events VALUES('2003-06-07','Jo G''s birthday drinks, 7:30pm @ [Boom!|http://www.streetmap.co.uk/streetmap.dll?G2M?X=526749&Y=175042&A=Y&Z=1] St John''s Hill nr Clapham');
INSERT INTO events VALUES('2003-05-31','Rich''s party at Alex and Alix''s.');
INSERT INTO events VALUES('2003-05-28','celia meet up with cleg');
INSERT INTO events VALUES('2003-06-23','Tim O''Reilly [speaking|http://www.ukuug.org/events/TimOReilly/] at City University');
INSERT INTO events VALUES('2003-06-02','[Spooks|http://www.bbc.co.uk/drama/spooks/] on');
INSERT INTO events VALUES('2003-06-01','Earle''s birthday at [The Windsor Castle|http://grault.net/cgi-bin/grubstreet.pl?Windsor_Castle,_W8_7AR]');
INSERT INTO events VALUES('2003-06-01','Lunch at Jenny''s');
INSERT INTO events VALUES('2003-06-06','Fiona and Angela''s 30th birthday');
INSERT INTO events VALUES('2003-06-05','London.pm');
INSERT INTO events VALUES('2003-06-04','Simon to Toucan on Soho Square at 7pm with Yoz re [this|http://www.historicalfact.com/ic/LondonNetScene?action=show]');
INSERT INTO events VALUES('2003-06-18','Drink with David');
INSERT INTO events VALUES('2003-06-20','Simon to Garage to go see Nerf Herder with Adam');
INSERT INTO events VALUES('2003-06-09','Simon to Munich');
INSERT INTO events VALUES('2003-06-12','Simon back from Munich');
INSERT INTO events VALUES('2003-06-18','Celia speaking at AIGA (report back from DUX)');
INSERT INTO events VALUES('2003-06-11','Celia -> Fiona');
INSERT INTO events VALUES('2003-06-13','Celia - lunch with Jon and Nick re IA work');
INSERT INTO events VALUES('2003-06-16','Celia - ring Mick Angel re lunch');
INSERT INTO events VALUES('2003-06-17','Celia -> Pete and Christopher');
INSERT INTO events VALUES('2003-07-08','Fi leaves for Brisbane');
INSERT INTO events VALUES('2003-07-22','Fi back from Australia');
INSERT INTO events VALUES('2003-06-25','Perrin in town');
INSERT INTO events VALUES('2003-07-23','YAPC Europe Starts');
INSERT INTO events VALUES('2003-07-25','YAPC Europe finished');
INSERT INTO events VALUES('2003-07-24','YAPC Europe');
INSERT INTO events VALUES('2003-07-05','Paintballing with Mark Eveleigh');
INSERT INTO events VALUES('2003-06-29','Warren Ellis at the [ICA|http://www.ica.org.uk/index.cfm?articleid=12293] at 3:30pm');
INSERT INTO events VALUES('2003-06-25','Simon physio appointment, 8:30am at Portland Place, 3 Gower Street');
INSERT INTO events VALUES('2003-06-28','Gayle''s hen night');
INSERT INTO events VALUES('2003-06-30','Leona''s birthday');
INSERT INTO events VALUES('2003-07-03','Celia -> Gayle');
INSERT INTO events VALUES('2003-07-02','Celia -> Nikki');
INSERT INTO events VALUES('2003-06-28','send flowers to mum');
INSERT INTO events VALUES('2003-06-27','RCA reception with Chris H/Orange ');
INSERT INTO events VALUES('2003-07-03','Simon -> London.pm');
INSERT INTO events VALUES('2003-07-03','Simon -> London.pm');
INSERT INTO events VALUES('2003-07-03','Simon -> London.pm');
INSERT INTO events VALUES('2003-07-03','Simon -> London.pm');
INSERT INTO events VALUES('2003-07-03','Simon -> London.pm');
INSERT INTO events VALUES('2003-07-03','Simon -> London.pm');
INSERT INTO events VALUES('2003-07-03','Simon -> London.pm');
INSERT INTO events VALUES('2003-07-03','Simon -> London.pm');
INSERT INTO events VALUES('2003-07-26','painball');
INSERT INTO events VALUES('2003-07-26','painball');
INSERT INTO events VALUES('2003-07-05','foo bar');
INSERT INTO events VALUES('2003-07-05','foo bar');
create table todos (description text not null);
INSERT INTO todos VALUES('(simon) IA and the WWW review');
INSERT INTO todos VALUES('(celia and simon) get carpets cleaned');
INSERT INTO todos VALUES('(simon) buy rack for games consoles');
INSERT INTO todos VALUES('(simon) rack for games consoles');
INSERT INTO todos VALUES('(celia) article for Tekka');
COMMIT;


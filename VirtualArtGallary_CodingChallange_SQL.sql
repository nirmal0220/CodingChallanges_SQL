create database VAG;
use VAG;

CREATE TABLE Artists ( 
ArtistID INT PRIMARY KEY,
Name VARCHAR(255) NOT NULL,
Biography TEXT, 
Nationality VARCHAR(100));

CREATE TABLE Categories ( 
CategoryID INT PRIMARY KEY, 
Name VARCHAR(100) NOT NULL
);

CREATE TABLE Artworks ( 
ArtworkID INT PRIMARY KEY,
Title VARCHAR(255) NOT NULL, 
ArtistID INT, 
CategoryID INT, 
Year INT, 
Description TEXT, 
ImageURL VARCHAR(255), 
FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID) on delete cascade, 
FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID) on delete cascade
);



CREATE TABLE Exhibitions ( 
ExhibitionID INT PRIMARY KEY, 
Title VARCHAR(255) NOT NULL, 
StartDate DATE, 
EndDate DATE,
Description TEXT
);

CREATE TABLE ExhibitionArtworks ( 
ExhibitionID INT, 
ArtworkID INT, 
PRIMARY KEY (ExhibitionID, ArtworkID), 
FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID) on delete cascade, 
FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID) on delete cascade);


INSERT INTO Artists (ArtistID, Name, Biography, Nationality) 
VALUES (1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'), 
(2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'), 
(3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');

INSERT INTO Categories (CategoryID, Name) 
VALUES (1, 'Painting'), (2, 'Sculpture'), (3, 'Photography');


INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) 
VALUES
(1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
(2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
(3, 'Guernica', 1, 1, 1937, 'Pablo Picasso powerful anti-war mural.', 'guernica.jpg');

INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
(1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
(2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');


INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 2);

--1)
select [dbo].[Artists].[Name],count([dbo].[Artworks].[ArtworkID]) as total_arkworks
from [dbo].[Artists] inner join [dbo].[Artworks] on
[dbo].[Artists].ArtistID=[dbo].[Artworks].ArtistID
group by [dbo].[Artists].[Name]
order by total_arkworks;

--2)
select [dbo].[Artworks].ArtistID, [dbo].[Artworks].Title as total_arkworks
from [dbo].[Artists] inner join [dbo].[Artworks] on
[dbo].[Artists].ArtistID=[dbo].[Artworks].ArtistID 
where [dbo].[Artists].Nationality='Spanish' or [dbo].[Artists].Nationality='Dutch'
order by [dbo].[Artworks].Year;

--3)
select [dbo].[Artists].Name, count([dbo].[Artworks].CategoryID)  as total_arkworks
from [dbo].[Artists] inner join [dbo].[Artworks] on
[dbo].[Artists].ArtistID=[dbo].[Artworks].ArtistID inner join [dbo].[Categories] on
[dbo].[Categories].[CategoryID]=[dbo].[Artworks].[ArtistID]
where [dbo].[Categories].Name='Painting'
group by [dbo].[Artists].Name,[dbo].[Categories].CategoryID ;

--4)
select [dbo].[Artworks].Title,[dbo].[Artists].[Name],[dbo].[Categories].[Name] 
from [dbo].[Categories] inner join [dbo].[Artworks]
on [dbo].[Categories].[CategoryID]=[dbo].[Artworks].[CategoryID]
inner join [dbo].[Artists] 
on [dbo].[Artists].ArtistID=[dbo].[Artworks].ArtistID
inner join [dbo].[ExhibitionArtworks]
on [dbo].[ExhibitionArtworks].ArtworkID=[dbo].[Artworks].ArtworkID
inner join [dbo].[Exhibitions] 
on [dbo].[Exhibitions].ExhibitionID=[dbo].[ExhibitionArtworks].ExhibitionID
where [dbo].[Exhibitions].Title='Modern Art Masterpieces';

--5)
select [dbo].[Artists].[Name] from [dbo].[Artists]
inner join [dbo].[Artworks] 
on [dbo].[Artists].[ArtistID]=[dbo].[Artworks].[ArtistID]
inner join [dbo].[ExhibitionArtworks] 
on [dbo].[ExhibitionArtworks].[ArtworkID]=[dbo].[Artworks].[ArtworkID]
group by [dbo].[Artists].[Name] having count(*)>2;

--6)
SELECT A.[Title] FROM [dbo].[Artworks] AS A
JOIN [dbo].[ExhibitionArtworks] AS EA
ON A.[ArtworkID]=EA.[ArtworkID]
JOIN [dbo].[Exhibitions] AS E
ON EA.[ExhibitionID]=E.[ExhibitionID]
WHERE E.[Title] IN
('Modern Art Masterpieces','Renaissance Art')
GROUP BY A.[Title]
HAVING COUNT(DISTINCT E.[Title])>=2;

--7)
SELECT [dbo].[Categories].[CategoryID],COUNT([dbo].[Artworks].[ArtworkID]) as  'Total' 
FROM [dbo].[Artworks]
FULL JOIN [dbo].[Categories]
ON [dbo].[Artworks].[CategoryID]=[dbo].[Categories].[CategoryID]
GROUP BY [dbo].[Categories].[CategoryID];

--8)
--No artists who have more than 3 artworks in My gallery so I used 0 here.
SELECT [Name] FROM [dbo].[Artists]
WHERE [ArtistID] IN
(SELECT [ArtistID] FROM [dbo].[Artworks]
GROUP BY [ArtistID]
HAVING COUNT([ArtworkID])>0);

--9)
SELECT * FROM [dbo].[Artworks]
WHERE [ArtistID] IN
(SELECT [ArtistID] FROM [dbo].[Artists]
WHERE [Nationality]='Spanish');

--10)
SELECT [dbo].[Exhibitions].[Title] FROM [dbo].[Exhibitions]
JOIN [dbo].[ExhibitionArtworks]
ON [dbo].[Exhibitions].[ExhibitionID]=[dbo].[ExhibitionArtworks].[ExhibitionID]
JOIN [dbo].[Artworks]
ON [dbo].[ExhibitionArtworks].[ArtworkID]=[dbo].[Artworks].[ArtworkID]
JOIN [dbo].[Artists]
ON [dbo].[Artworks].[ArtistID]=[dbo].[Artists].[ArtistID]
WHERE [dbo].[Artists].[Name] IN
('Vincent van Gogh','Leonardo da Vinci')
GROUP BY [dbo].[Exhibitions].[ExhibitionID],[dbo].[Exhibitions].[Title]
;

--11)
-- There is no artwork that have not been included in any exhibition so result is None

SELECT * FROM [dbo].[Artworks]
WHERE [ArtworkID] NOT IN
(SELECT [ArtworkID] FROM [dbo].[ExhibitionArtworks]);

--12)
SELECT [dbo].[Artists].[Name] FROM [dbo].[Artists]
FULL JOIN [dbo].[Artworks]
ON [dbo].[Artists].[ArtistID]=[dbo].[Artworks].[ArtistID]
GROUP BY [dbo].[Artists].[Name] 
HAVING COUNT([dbo].[Artworks].[ArtworkID])
IN (SELECT COUNT([ArtworkID]) FROM [dbo].[Artworks]
GROUP BY [CategoryID]);

--13)
SELECT [dbo].[Categories].[CategoryID],COUNT([dbo].[Artworks].[ArtworkID]) as 'Total' FROM [dbo].[Artworks]
FULL JOIN [dbo].[Categories]
ON [dbo].[Artworks].[CategoryID]=[dbo].[Categories].[CategoryID]
GROUP BY [dbo].[Categories].[CategoryID];

--14)
--I am using 0 here to check result

SELECT [dbo].[Artists].[Name] 
FROM [dbo].[Artists]
JOIN [dbo].[Artworks]
ON [dbo].[Artists].[ArtistID]=[dbo].[Artworks].[ArtistID]
GROUP BY [dbo].[Artworks].[ArtistID],[dbo].[Artists].[Name]
HAVING COUNT([dbo].[Artworks].[ArtworkID])>=1;

--15)
SELECT [dbo].[Categories].[CategoryID],[dbo].[Categories].[Name],AVG([dbo].[Artworks].[Year]) as 'Average_Year' 
FROM [dbo].[Categories] FULL JOIN [dbo].[Artworks]
ON [dbo].[Categories].[CategoryID]=[dbo].[Artworks].[CategoryID]
GROUP BY [dbo].[Categories].[CategoryID],[dbo].[Categories].[Name]
HAVING COUNT([dbo].[Artworks].[ArtworkID])>1;

--16)
SELECT [dbo].[Artworks].[Title] FROM [dbo].[Artworks]
JOIN [dbo].[ExhibitionArtworks]
ON [dbo].[Artworks].[ArtworkID]=[dbo].[ExhibitionArtworks].[ArtworkID]
JOIN [dbo].[Exhibitions]
ON [dbo].[ExhibitionArtworks].[ExhibitionID]=[dbo].[Exhibitions].[ExhibitionID]
WHERE [dbo].[Exhibitions].[Title]='Modern Art Masterpieces';

--17)
SELECT [dbo].[Categories].[CategoryID],[dbo].[Categories].[Name] FROM [dbo].[Categories]
FULL JOIN [dbo].[Artworks] ON [dbo].[Categories].[CategoryID]=[dbo].[Artworks].[CategoryID]
GROUP BY [dbo].[Categories].[CategoryID],[dbo].[Categories].[Name]
HAVING AVG([dbo].[Artworks].[Year]) > (SELECT AVG([Year]) FROM [dbo].[Artworks]);

--18)
SELECT * FROM [dbo].[Artworks]
WHERE [ArtworkID] NOT IN
(SELECT [ArtworkID] FROM [dbo].[ExhibitionArtworks]);

--19)

SELECT [dbo].[Artists].[Name],[dbo].[Categories].[CategoryID] 
FROM [dbo].[Artists] JOIN [dbo].[Artworks]
ON [dbo].[Artists].[ArtistID]=[dbo].[Artworks].[ArtistID]
JOIN [dbo].[Categories]
ON [dbo].[Artworks].[CategoryID]=[dbo].[Categories].[CategoryID]
WHERE [dbo].[Categories].[CategoryID] = 
(SELECT [CategoryID] FROM [dbo].[Artworks]
WHERE [Title]='Mona Lisa');

--20)
SELECT COUNT([dbo].[Artworks].[ArtworkID]) as 'Total', [dbo].[Artists].[Name] 
FROM [dbo].[Artists] JOIN [dbo].[Artworks]
ON  [dbo].[Artists].ArtistID=[dbo].[Artworks].[ArtistID]
GROUP BY  [dbo].[Artists].[Name],[dbo].[Artists].[Name];
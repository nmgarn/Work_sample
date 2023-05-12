alter table Book_tag
DROP CONSTRAINT book_tag_fk1;

alter table book_genre
Drop CONSTRAINT book_genre_fk1;

DROP TABLE LOAN;
DROP TABLE SERIES;
DROP TABLE Digital_books;
DROP TABLE Audio_Books;
DROP TABLE L_USER;
DROP TABLE Author;
DROP TABLE Book;
DROP TABLE Book_tag;
DROP TABLE Book_genre;


CREATE TABLE Book_tag(
  Tag_Name varchar2(32),
  t_ISBN char (14),
  CONSTRAINT Book_tag_pk PRIMARY KEY (Tag_Name)
  );
 
  INSERT INTO book_tag VALUES ('scary', '1234432156');

  
CREATE TABLE Book_genre(
  Genre_name varchar2(32),
  g_ISBN char(14),
  CONSTRAINT Book_genre_pk PRIMARY KEY (Genre_Name,g_isbn)
);

INSERT INTO Book_genre VALUES ('Science Fiction','1234567891');

CREATE TABLE Book (
  ISBN CHAR(14) NOT NULL,
  Title varchar2(256) NOT NULL,
  Audience varchar2(128),
  Language varchar2(32),
  Release_Date DATE, 
  CONSTRAINT book_pk PRIMARY KEY (ISBN)
);

INSERT INTO book
Values('1234432156','The Fellowship of the Ring', 'Everybody','English', '11-27-21')

CREATE TABLE Author (
  First_Name varchar2(64) NOT NULL,
  Last_Name varchar2(64) NOT NULL,
  Middle_Initial varchar2(2) NOT NULL,
  ISBN char(14),
CONSTRAINT Author_pk PRIMARY KEY (First_name, Last_name, Middle_initial),
CONSTRAINT Author_fk1 FOREIGN KEY (ISBN) REFERENCES Book (ISBN)
);

CREATE TABLE L_User(
  Library_card_number Char(14) NOT NULL,
  U_First_Name varchar2(64) NOT NULL,
  U_Last_Name varchar2(64) NOT NULL,
CONSTRAINT User_pk PRIMARY KEY (Library_card_number)  

);

CREATE TABLE SERIES (
  First_Book_ISBN CHAR(14) NOT NULL,
  Series_Name varchar2(128) NOT NULL,
  s_ISBN CHAR(14) NOT NULL,
CONSTRAINT Table_pk PRIMARY KEY (First_Book_ISBN,s_ISBN),
CONSTRAINT series_fk1 FOREIGN KEY (s_ISBN) REFERENCES book (ISBN)

);

CREATE TABLE Audio_Books(
  AB_publisher varchar2(64) NOT NULL,
  Copy_Number Char(10),
  Duration Char(4),
  Narrator varchar2(128),
  a_ISBN CHAR(14),
  CONSTRAINT Audio_book_fk1 FOREIGN KEY (a_ISBN) REFERENCES Book (ISBN)
  
);

Create TABLE Digital_books(
  Digital_Publisher varchar2(64),
  Support_Platform varchar2(64),
  Copy_Number CHAR(10),
  d_ISBN CHAR(14),
  CONSTRAINT Digital_books_fk1 FOREIGN KEY (d_ISBN) REFERENCES Book (ISBN)
);

 
 CREATE TABLE Loan (
 USERID char(14),
 Return_date DATE,
 L_ISBN char(14),
 CONSTRAINT Loan_FK1 FOREIGN KEY (L_ISBN) REFERENCES Book (ISBN),
 CONSTRAINT Loan_FK2 FOREIGN KEY (USERID) REFERENCES l_User (Library_card_number)
 );
 
 
 ALTER TABLE book_tag
 ADD CONSTRAINT Book_tag_Fk1 FOREIGN KEY (t_ISBN) REFERENCES Book (ISBN); 

ALTER TABLE book_genre
 ADD CONSTRAINT book_genre_fk1 FOREIGN KEY (g_ISBN) REFERENCES Book (ISBN);
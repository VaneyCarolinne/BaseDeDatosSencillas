CREATE database canciones_favoritas template template1;

\c canciones_favoritas

CREATE SCHEMA song;

/* Creacion de DOMINIOS */
CREATE DOMAIN song.cad1 varchar (60);/*nombre cancion*/

CREATE DOMAIN song.cad2 varchar (30);/*tipo_artista,  nombre_artista*/

CREATE DOMAIN song.cad4 varchar (130);/*reseña*/

CREATE DOMAIN song.fecha date; 
			  
CREATE DOMAIN song.tipo_Artista varchar (30)
			  check (VALUE in ('solista','banda'))
			  default 'desconocido';
			  
CREATE DOMAIN song.tipo_formato char(4)
			  default 'MP3';

/*CREACION DE LAS TABLAS DE LA BD*/

CREATE TABLE song.Artista(

	nombre song.cad2 not null, 
	fecha_nacimiento song.fecha not null,
	tipo_artista varchar(30), /*Banda , solista*/
	primary key(nombre, fecha_nacimiento)
);

CREATE TABLE song.Cancion(

	nombre_cancion song.cad1 not null,
	fecha_grabacion song.fecha not null,
	fecha_nacimiento song.fecha not null,
	nombre_artista  song.cad2 not null,
	duracion time not null,
	resena song.cad4 not null, /* historia de las canciones */
	disco song.cad1 not null,
	formato song.tipo_formato not null,
	primary key(nombre_cancion,fecha_grabacion, nombre_artista),
	foreign key (nombre_artista, fecha_nacimiento) references song.Artista
	on delete cascade
	on update cascade
);

/*Carga de datos*/

insert into song.Artista (nombre,fecha_nacimiento,tipo_artista)
values('Shakira','1986-07-22','solista');
insert into song.Artista (nombre,fecha_nacimiento,tipo_artista)
values('Selena Gomez','1992-07-22','solista');
insert into song.Artista (nombre,fecha_nacimiento,tipo_artista)
values('Franco de Vita', '1959-07-22' ,'solista');
insert into song.Artista (nombre,fecha_nacimiento,tipo_artista)
VALUES ('Metallica','1991-01-13','banda');
insert into song.Artista (nombre,fecha_nacimiento, tipo_artista)
VALUES ('Guns and Roses','1985-01-13','banda');

INSERT INTO song.Cancion (nombre_cancion, fecha_grabacion, nombre_artista, duracion, fecha_nacimiento, resena, disco, formato) 
VALUES ('November Rain','1992-12-26','Guns and Roses','9:07','1985-01-13','es una de las canciones más famosas', 'Use Your Illusion I', 'MP3');
INSERT INTO song.Cancion (nombre_cancion, fecha_grabacion, nombre_artista, duracion, fecha_nacimiento, resena, disco, formato) 
VALUES ('Nothing Else Matters','1992-12-26','Metallica', '6:25','1991-01-13','es una balada de la banda estadounidense de thrash metal Metallica. ', 'The Black Album', 'MP3');
INSERT INTO song.Cancion (nombre_cancion, fecha_grabacion, nombre_artista, duracion, fecha_nacimiento, resena, disco, formato) 
VALUES ('Same Old Love','2015-11-09','Selena Gomez','4:25','1992-07-22','es una canción de la cantante estadounidense Selena Gomez, incluida en su segundo álbum de estudio como solista, Revival', 'Revival', 'MP3');
INSERT INTO song.Cancion (nombre_cancion, fecha_grabacion, nombre_artista, duracion, fecha_nacimiento, resena, disco, formato) 
VALUES ('Si te vas','2001-11-09','Shakira', '5:25','1986-07-22','es una canción de la cantante colombiana Shakira', 'Pies descalzos ', 'MP3');
INSERT INTO song.Cancion (nombre_cancion, fecha_grabacion, nombre_artista, duracion, fecha_nacimiento, resena, disco, formato) 
VALUES ('No basta','2006-12-07','Franco de Vita', '6:00','1959-07-22','es una canción del cantante Venezolano Franco de vita', 'Primera fila', 'MP3');


SELECT * FROM song.Artista;
SELECT * FROM song.Cancion;
/*Creación de trigger*/

CREATE OR REPLACE FUNCTION insertar_trigger() RETURNS TRIGGER AS $insertar$
DECLARE BEGIN 
		
		INSERT INTO song.Artista VALUES (NEW.nombre_artista,NEW.fecha_nacimiento,'desconocido');
		RETURN NEW;

END;
$insertar$ LANGUAGE plpgsql;

/*Para insertar*/
CREATE TRIGGER insertar_artista BEFORE INSERT 
ON song.Cancion FOR EACH ROW 
EXECUTE PROCEDURE insertar_trigger();

INSERT INTO song.Cancion (nombre_cancion, fecha_grabacion, nombre_artista, duracion, fecha_nacimiento, resena, disco, formato)
VALUES ('Hurt','2006-11-09','Christina Aguilera','6:25','1989-07-22','es una canción de la cantante estadounidense Christina Aguilera', 'Back to Basics', 'MP3');


SELECT * FROM song.Artista;
SELECT * FROM song.Cancion;

/*Para actualizar*/
CREATE TRIGGER actualizar BEFORE UPDATE 
ON song.Cancion FOR EACH ROW 
EXECUTE PROCEDURE insertar_trigger();

UPDATE song.Cancion set nombre_cancion='Revival Music', nombre_artista='Selana Gomez and The Scene', fecha_nacimiento='2006-07-07'
WHERE nombre_artista='Selena Gomez';

SELECT * FROM song.Artista;
SELECT * FROM song.Cancion;

import mysql from 'mysql2'

let connection: mysql.Connection;

export const createConnection = () => {
	console.log(process.env.DB_USER)
	connection = mysql.createConnection({
		host: 'mon_mysql',
		//host: "127.0.0.1",
		port: 3306,
		user: process.env.DB_USER,
		password: process.env.DB_PASSWORD,
		database: process.env.DB_NAME,
	})

	connection.connect((err: any) => {
		if (err) {
			console.error('Erreur de connexion à la base de données :', err);
		} else {
			console.log('Connecté à la base de données MySQL !');
		}
	});
};

export const getConnection = () => {
	if (!connection) {
		throw new Error('La connexion à la base de données n\'a pas encore été établie.');
	}
	return connection;
};
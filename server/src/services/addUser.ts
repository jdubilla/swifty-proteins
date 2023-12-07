import argon2 from 'argon2'
import { getConnection } from './connectiondb';
import { generateJWT } from '../utils/token';

export const addUser = async (username: string, password: string) => {
	const connection = getConnection()
	const hashedPassword = await argon2.hash(password)

	try {

	const addUserQuery = 'INSERT INTO user (username, password) VALUES (?, ?);';
		const values = [username, hashedPassword]
		const createUserResult: any = await new Promise((resolve, reject) => {
			connection.query(addUserQuery, values, (err: any, result: any) => {
				if (err) {
					reject(new Error('Internal error, please try again later'));
				} else {
					resolve(result)
				}
			})
		})
		const token = generateJWT(createUserResult.insertId);
		
		return token;
	} catch (error) {
		throw error;
	}
}
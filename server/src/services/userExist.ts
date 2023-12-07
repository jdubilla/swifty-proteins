import { getConnection } from './connectiondb'

export const userExist = async (username: string): Promise<any> => {
	const connection = getConnection()

	const userQuery = 'SELECT * FROM user WHERE username = ?';
		const userResult: any = await new Promise((resolve, reject) => {
			connection.query(userQuery, username, (checkUserErr: any, checkUserResults: any) => {
				if (checkUserErr) {
					reject(new Error('An error occurred while verifying the username'));
				} else {
					resolve(checkUserResults);
				}
			});
		});
		if (userResult.length === 0) {
			return null
		}
		return userResult[0]
}
import jwt from 'jsonwebtoken';

export function generateJWT(userId: number) {
	const payload = {
		userId: userId,
		createdDate: Date()
	};

	const secretKey = process.env.SECRET_JWT;

	if (!secretKey) {
		throw new Error('Secret key undefined');
	}

	const token = jwt.sign(payload, secretKey);

	return token;
}

export async function verifyToken(token: string, secretKey: string) {
	return new Promise((resolve, reject) => {
		jwt.verify(token, secretKey, (err, user) => {
			if (err) {
				reject(new Error("Invalid token"));
			} else {
				resolve(user);
			}
		});
	});
}
import jwt from 'jsonwebtoken';

export function generateJWT(userId: number) {
	const payload = {
		userId: userId,
		createdDate: Date()
	};

	const secretKey = process.env.SECRET_JWT;

	if (!secretKey) {
		throw new Error('La clé secrète JWT est manquante dans les variables d\'environnement.');
	}

	const token = jwt.sign(payload, secretKey);

	return token;
}
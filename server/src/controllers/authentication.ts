import { Request, Response } from 'express';
import { userExist } from '../services/userExist';
import { addUser } from '../services/addUser';

function checkPassword(password: string, confPassword: string): boolean {
	const regex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]+$/;

	if (password !== confPassword) {
		return false
	}

	if (password.length < 6) {
		return false
	}

	return regex.test(password);
}

function checkParams(username: string, password: string, confPassword: string): boolean {
	if (!username || !password || !confPassword) {
		return false
	}

	if (username.length < 3 || username.length > 10) {
		return false
	}

	if (!checkPassword(password, confPassword)) {
		return false
	}

	return true
}

export const signup = async (req: Request, res: Response) => {
	const { username, password, confPassword } = req.body

	if (!checkParams(username, password, confPassword)) {
		return res.status(400).json({error: "Bad request"})
	}

	if (await userExist(username)) {
		return res.status(409).json({error: "Username is already taken"})
	}

	try {
		const token = await addUser(username, password)

		res.status(200).json({token : token})
	} catch(error) {
		return res.status(500).json({ error: 'Internal error, please try again later' });
	}
}
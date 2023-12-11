import { Request, Response } from 'express';
import { userExist } from '../services/userExist';
import { addUser } from '../services/addUser';

function checkPassword(password: string, confPassword: string) {
	const regex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]+$/;

	if (password !== confPassword) {
		throw new Error("Passwords must be sames")
	}

	if (password.length < 6 || !regex.test(password)) {
		throw new Error("Bad password")
	}
}

function checkParams(username: string, password: string, confPassword: string) {
	if (!username || !password || !confPassword) {
		throw new Error("Missing required params")
	}

	if (username.length <= 3 || username.length > 15) {
		throw new Error("Bad username")
	}

	checkPassword(password, confPassword)

}

export const signup = async (req: Request, res: Response) => {
	try {
		const { username, password, confPassword } = req.body

	checkParams(username, password, confPassword)

	if (await userExist(username)) {
		return res.status(409).json({error: "Username is already taken"})
	}

		const token = await addUser(username, password)
		console.log(token)

		res.status(200).json({token : token})
	} catch(error: any) {
		return res.status(500).json({ error: error.message });
	}
}

export const test = async (req: Request, res: Response) => {
	//try {
	//	console.log("Signup call")
	//	const { username, password, confPassword } = req.body
	//	console.log(username, password, confPassword)

	//checkParams(username, password, confPassword)

	//if (await userExist(username)) {
	//	return res.status(409).json({error: "Username is already taken"})
	//}

	//	const token = await addUser(username, password)
	//	console.log(token)

		res.status(200).json({OK : "OKTest"})
	//} catch(error: any) {
		//return res.status(500).json({ error: error.message });
	//}
}
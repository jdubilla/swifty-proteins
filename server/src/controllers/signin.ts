import { Request, Response } from "express";
import argon2 from 'argon2'
import { userExist } from "../services/userExist";
import { generateJWT } from "../utils/token";

function checkParams(username: string, password: string) {
	if (!username || !password) {
		throw new Error("Missing required params")
	}
}

export const signin = async (req: Request, res: Response) => {
	try {
		const { username, password } = req.body

		checkParams(username, password)

		const user = await userExist(username)
		if (!user) {
			throw new Error("Username don\'t exist")
		}

		const storedPassword = user.password
		const passwordMatch = await argon2.verify(storedPassword, password)
		if (!passwordMatch) {
			throw new Error("Bad password")
		}

		const token = generateJWT(user.id)
		return res.json({ token: token });

	} catch(error: any) {
		return res.status(500).json({ error: error.message });
	}
}
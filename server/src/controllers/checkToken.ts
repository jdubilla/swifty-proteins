import { Request, Response } from "express";
import { verifyToken } from "../utils/token";

export const checkToken = async (req: Request, res: Response) => {
	try {
		const token = String(req.query.token)
		const secretKey = process.env.SECRET_JWT

		if (!token) {
			throw new Error("Missing required params")
		}

		if (!secretKey) {
			throw new Error("Secret key undefined")
		}

		const user = await verifyToken(token, secretKey)
		return res.status(200).json(user);

	} catch (error: any) {
		console.log(error.message)
		return res.status(500).json({ error: error.message });
	}
}
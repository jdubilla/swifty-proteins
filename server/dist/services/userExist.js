"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.userExist = void 0;
const connectiondb_1 = require("./connectiondb");
const userExist = (username) => __awaiter(void 0, void 0, void 0, function* () {
    const connection = (0, connectiondb_1.getConnection)();
    const userQuery = 'SELECT * FROM user WHERE username = ?';
    const userResult = yield new Promise((resolve, reject) => {
        connection.query(userQuery, username, (checkUserErr, checkUserResults) => {
            if (checkUserErr) {
                reject(new Error('An error occurred while verifying the username'));
            }
            else {
                resolve(checkUserResults);
            }
        });
    });
    if (userResult.length === 0) {
        return null;
    }
    return userResult[0];
});
exports.userExist = userExist;

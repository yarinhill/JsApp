const express = require("express");

const authConrtoller = require("../controllers/authController");

const router = express.Router();

router.post("/signup",authConrtoller.signUp);
router.post("/login",authConrtoller.login)


module.exports = router
"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.saveToken = exports.onOrderStatusChange = void 0;
const functions = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
// Initialize the admin SDK
admin.initializeApp();
const db = admin.firestore();
/**
 * Trigger: on update of an order document. When `status` changes, send an FCM
 * message to the device token stored on the user document (field: `fcmToken`).
 *
 * Notes:
 * - Ensure each user document stores a current `fcmToken` (client writes token on sign-in).
 * - If you use topic messaging or multiple tokens per user adapt accordingly.
 */
exports.onOrderStatusChange = functions.firestore
    .document('orders/{orderId}')
    .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    if (!before || !after)
        return null;
    const prevStatus = before.status;
    const newStatus = after.status;
    if (!newStatus || prevStatus === newStatus)
        return null;
    const orderId = context.params.orderId;
    const userId = after.userId;
    if (!userId)
        return null;
    try {
        const userDoc = await db.collection('users').doc(userId).get();
        if (!userDoc.exists)
            return null;
        const fcmToken = userDoc.get('fcmToken');
        if (!fcmToken)
            return null;
        const payload = {
            notification: {
                title: 'Order Update',
                body: `Order ${orderId.substring(0, 6)} is now ${newStatus}`,
            },
            data: {
                orderId,
                status: newStatus,
            },
        };
        // Send to a single device token
        await admin.messaging().sendToDevice(fcmToken, payload);
        return null;
    }
    catch (err) {
        console.error('onOrderStatusChange error:', err);
        return null;
    }
});
/**
 * HTTP helper to save a device token to a user document.
 * POST JSON: { uid: string, token: string }
 * Header: x-admin-secret: <ADMIN_SECRET> (set as environment variable)
 */
exports.saveToken = functions.https.onRequest(async (req, res) => {
    try {
        if (req.method !== 'POST')
            return res.status(405).send('Method Not Allowed');
        // Support both runtime env var and functions config
        const secret = process.env.ADMIN_SECRET || functions.config()?.admin?.secret;
        const provided = req.header('x-admin-secret');
        if (!secret || provided !== secret)
            return res.status(401).send('Unauthorized');
        const { uid, token } = req.body;
        if (!uid || !token)
            return res.status(400).send('uid and token required');
        await db.collection('users').doc(uid).set({ fcmToken: token }, { merge: true });
        return res.status(200).send('ok');
    }
    catch (err) {
        console.error('saveToken error', err);
        return res.status(500).send('error');
    }
});
//# sourceMappingURL=index.js.map
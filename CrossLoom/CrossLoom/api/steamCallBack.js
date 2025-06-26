import { OpenID } from 'openid';

const relyingParty = new OpenID.RelyingParty(
  'https://cross-loom.vercel.app/api/steamCallback', // return URL
  'https://cross-loom.vercel.app',                   // realm
  true,                                                  // stateless
  false,                                                 // strict mode
  []                                                     // extensions
);

export default function handler(req, res) {
  relyingParty.verifyAssertion(req.url, (error, result) => {
    if (error || !result || !result.claimedIdentifier) {
      return res.status(403).send('Autenticazione fallita.');
    }

    const steamID = result.claimedIdentifier.split('/').pop();
    const redirectToApp = `myapp://steam-auth?steamid=${steamID}`;
    res.redirect(redirectToApp);
  });
}

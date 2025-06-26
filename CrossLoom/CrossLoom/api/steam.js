export default function handler(req, res) {
    const returnUrl = 'https://cross-loom-bsqr.vercel.app/api/steamCallback';
  
  const params = new URLSearchParams({
    'openid.ns': 'http://specs.openid.net/auth/2.0',
    'openid.mode': 'checkid_setup',
    'openid.return_to': returnUrl,
      'openid.realm': 'https://cross-loom-bsqr.vercel.app',
    'openid.identity': 'http://specs.openid.net/auth/2.0/identifier_select',
    'openid.claimed_id': 'http://specs.openid.net/auth/2.0/identifier_select'
  });

  const steamLoginUrl = `https://steamcommunity.com/openid/login?${params.toString()}`;
  res.redirect(steamLoginUrl);
}

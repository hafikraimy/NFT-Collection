export default function handler(req, res) {
  // get the token id from the query params
  const tokenId = req.query.tokenId;

  const name = `Crypto Dev #${tokenId}`;
  // extract image from github directly
  const image = `https://raw.githubusercontent.com/hafikraimy/NFT-Collection/main/my-app/public/cryptodevs/${
    Number(tokenId) - 1
  }/.svg`;
  const description = "Crypto Dev is an NFT Collection for Web3 Developers";

  res.status(200).json({
    name: name,
    description: description,
    image: image,
  });
}

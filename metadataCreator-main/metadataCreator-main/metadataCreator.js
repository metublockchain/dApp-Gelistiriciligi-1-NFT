const fs = require('fs');

const collectionName = '111 adet Logo';
const collectionSize = 111;

const imageIpfs = 'ipfs://bafybeieaf3lrag6lswjlaq3splrizin2mivaon4fiqteifxxaurhk6x4cu/';
const description = '111 tane odtü blockchain logosu';

for (num = 1; num <= collectionSize; num++) {
	// creates JSON objects
	const metadata = {
		name: `${collectionName} #${num}`,
		description: `${description}`,
		image: `${imageIpfs}(${num}).jpg`
	};

	// convert JSON object to string
	const data = JSON.stringify(metadata);

	fs.mkdirSync('metadata', { recursive: true });
	// write JSON string to a file
	fs.writeFile(`./metadata/${num}.json`, data, (err) => {
		if (err) {
			throw err;
		}
		console.log('JSON datas are saved.');
	});
}

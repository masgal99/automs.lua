const express = require('express');
const axios = require('axios');

const app = express();

// CONFIG
const GITHUB_TOKEN = process.env.GITHUB_TOKEN;
const GIST_ID = process.env.GIST_ID;
// GET DATA
async function getData() {
    const res = await axios.get(`https://api.github.com/gists/${GIST_ID}`, {
        headers: { Authorization: `token ${GITHUB_TOKEN}` }
    });

    return JSON.parse(res.data.files['keys.json'].content);
}

// SAVE DATA
async function saveData(data) {
    await axios.patch(`https://api.github.com/gists/${GIST_ID}`, {
        files: {
            'keys.json': {
                content: JSON.stringify(data, null, 2)
            }
        }
    }, {
        headers: { Authorization: `token ${GITHUB_TOKEN}` }
    });
}

// API VALIDATE
app.get('/validate', async (req, res) => {
    const { key, hwid } = req.query;

    if (!key || !hwid) {
        return res.json({ status: 'invalid' });
    }

    const data = await getData();
    const k = data.keys.find(x => x.key === key);

    if (!k) return res.json({ status: 'invalid' });

    // EXPIRED
    if (k.expired && Date.now() > k.expired)
        return res.json({ status: 'expired' });

    // HWID LOCK
    if (!k.hwid) {
        k.hwid = hwid;
        await saveData(data);
    } else if (k.hwid !== hwid) {
        return res.json({ status: 'hwid_mismatch' });
    }

    return res.json({ status: 'valid' });
});

app.listen(3000, () => console.log('API RUNNING'));

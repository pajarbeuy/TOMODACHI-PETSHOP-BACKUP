const fs = require('fs');
const path = require('path');

const dir = __dirname;
const files = fs.readdirSync(dir).filter(f => f.endsWith('.yaml'));

for (const file of files) {
    const filePath = path.join(dir, file);
    let content = fs.readFileSync(filePath, 'utf8');
    let changed = false;

    if (content.includes('- tapOn: "Email Address"')) {
        content = content.replace(/- tapOn: "Email Address"/g, '- tapOn: "you@example.com"');
        changed = true;
    }

    if (content.includes('- tapOn: "Password"')) {
        content = content.replace(/- tapOn: "Password"/g, '- tapOn: "Enter your password"');
        changed = true;
    }

    if (changed) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`Updated ${file}`);
    }
}

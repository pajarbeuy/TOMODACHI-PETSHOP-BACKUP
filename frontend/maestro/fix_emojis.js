const fs = require('fs');
const path = require('path');

const dir = 'c:\\laragon\\www\\nEW\\TOMODACHI-PETSHOP-BACKUP\\frontend\\maestro';
const files = fs.readdirSync(dir).filter(f => f.endsWith('.yaml') && !f.startsWith('login_'));

for (const file of files) {
    const filePath = path.join(dir, file);
    let content = fs.readFileSync(filePath, 'utf8');
    let changed = false;

    if (content.includes('- tapOn: "👑"')) {
        content = content.replace('- tapOn: "👑"', '- runFlow:\n    file: "login_admin.yaml"');
        changed = true;
    }
    if (content.includes('- tapOn: "🏪"')) {
        content = content.replace('- tapOn: "🏪"', '- runFlow:\n    file: "login_kasir.yaml"');
        changed = true;
    }
    if (content.includes('- tapOn: "🏆"')) {
        content = content.replace('- tapOn: "🏆"', '- runFlow:\n    file: "login_owner.yaml"');
        changed = true;
    }
    
    // Also fix the Login text replacement just in case
    if (content.includes('- tapOn:\r\n    text: "Login"')) {
        content = content.replace(/- tapOn:\r?\n\s+text: "Login"/g, '- tapOn: "Sign In"');
        changed = true;
    }
    if (content.includes('- tapOn:\n    text: "Login"')) {
        content = content.replace(/- tapOn:\r?\n\s+text: "Login"/g, '- tapOn: "Sign In"');
        changed = true;
    }
    if (content.includes('- tapOn: "Email"')) {
        content = content.replace(/- tapOn: "Email"/g, '- tapOn: "Email Address"');
        changed = true;
    }

    if (changed) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`Updated ${file}`);
    }
}

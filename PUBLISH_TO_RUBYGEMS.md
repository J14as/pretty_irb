# 📦 Publishing Pretty IRB to RubyGems

Complete guide to build and publish your gem to the official RubyGems repository.

---

## 📋 Pre-Publication Checklist

Before publishing, ensure:

- [ ] Version number updated in `lib/pretty_irb/version.rb`
- [ ] All tests passing: `bundle exec rspec`
- [ ] No syntax errors: `bundle exec rubocop` (optional)
- [ ] README.md is complete and accurate
- [ ] CHANGELOG.md created (recommended)
- [ ] LICENSE.txt file present
- [ ] .gemspec file is correct with all required fields
- [ ] gem built successfully locally

---

## Step 1: Update Version Number

Edit `lib/pretty_irb/version.rb`:

```ruby
module PrettyIRB
  VERSION = "0.1.0"
end
```

Choose version using Semantic Versioning:
- **0.1.0** - Initial release (Major.Minor.Patch)
- **0.2.0** - New features added
- **0.2.1** - Bug fixes only
- **1.0.0** - Stable production version

---

## Step 2: Verify .gemspec File

Check `pretty_irb.gemspec` has all required fields:

```ruby
spec.name          = "pretty_irb"
spec.version       = PrettyIRB::VERSION
spec.authors       = ["Your Name"]
spec.email         = ["your.email@example.com"]
spec.summary       = "Beautiful, feature-rich Ruby REPL"
spec.description   = "Enhanced Interactive Ruby Shell with syntax highlighting, auto-correct, AI helper, and more"
spec.homepage      = "https://github.com/yourusername/pretty_irb"
spec.license       = "MIT"

spec.files         = `git ls-files -z`.split("\x0")
spec.bindir        = "exe"
spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
spec.require_paths = ["lib"]

spec.required_ruby_version = ">= 2.7.0"

spec.add_dependency "irb", ">= 1.0"
spec.add_dependency "reline", "~> 0.3"
spec.add_dependency "colorize", "~> 0.8"
spec.add_dependency "rouge", "~> 3.26"
spec.add_dependency "did_you_mean", "~> 1.5"
```

**Important updates needed:**
- Change `authors` to your name
- Change `email` to your email
- Update `homepage` to your GitHub repo URL
- Verify all dependencies are correct

---

## Step 3: Create a RubyGems Account

If you don't have one:

1. Go to https://rubygems.org
2. Click "Sign up"
3. Fill in username, email, password
4. Verify email address
5. Save your API key (copy from Settings → API Keys)

---

## Step 4: Set Up Local Credentials

Create `~/.gem/credentials` file:

```bash
mkdir -p ~/.gem
touch ~/.gem/credentials
chmod 600 ~/.gem/credentials
```

Edit `~/.gem/credentials` and add:

```yaml
---
:rubygems_api_key: your_api_key_here
```

**Windows PowerShell** - Create file manually:
```powershell
# Create directory
New-Item -ItemType Directory -Path "$env:USERPROFILE\.gem" -Force

# Create credentials file
$credentials = @"
---
:rubygems_api_key: your_api_key_here
"@

$credentials | Out-File -FilePath "$env:USERPROFILE\.gem\credentials" -Encoding ASCII
```

Then set permissions (if on Windows with WSL):
```bash
chmod 600 ~/.gem/credentials
```

**Alternative: Use gemcutter gem**
```bash
gem install gemcutter
gem tumble  # Interactive setup
```

---

## Step 5: Build the Gem

Navigate to your project directory:

```bash
cd c:\Users\Jayesh\Music\ROR\pretty_irb
```

Build the gem:

```bash
gem build pretty_irb.gemspec
```

Output: `pretty_irb-0.1.0.gem` file created

Verify the build:
```bash
gem list --local pretty_irb
```

---

## Step 6: Test the Gem Locally (Optional but Recommended)

Install from the local gem file:

```bash
gem install ./pretty_irb-0.1.0.gem
```

Test it works:
```bash
pretty_irb
```

Uninstall for testing:
```bash
gem uninstall pretty_irb
```

---

## Step 7: Publish to RubyGems

Push the gem to RubyGems:

```bash
gem push pretty_irb-0.1.0.gem
```

**Expected output:**
```
Pushing gem to https://rubygems.org...
Successfully registered gem: pretty_irb (0.1.0)
```

---

## Step 8: Verify Publication

Check RubyGems:

1. Visit: https://rubygems.org/gems/pretty_irb
2. Or search: https://rubygems.org/search?query=pretty_irb
3. Or check in terminal:
```bash
gem search pretty_irb
gem search pretty_irb -r  # -r checks remote
```

---

## Step 9: Install from RubyGems (Public)

Anyone can now install with:

```bash
gem install pretty_irb
```

Or in Gemfile:
```ruby
gem 'pretty_irb'
bundle install
```

---

## Updating to a New Version

When you want to release version 0.2.0:

1. **Update version** in `lib/pretty_irb/version.rb`:
   ```ruby
   VERSION = "0.2.0"
   ```

2. **Update CHANGELOG.md** with changes

3. **Commit to Git**:
   ```bash
   git add .
   git commit -m "Release v0.2.0"
   git tag v0.2.0
   git push origin main
   git push origin v0.2.0
   ```

4. **Build and Push**:
   ```bash
   gem build pretty_irb.gemspec
   gem push pretty_irb-0.2.0.gem
   ```

---

## Complete Workflow Script

Save this as `publish.sh`:

```bash
#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get version from lib/pretty_irb/version.rb
VERSION=$(grep 'VERSION = ' lib/pretty_irb/version.rb | sed 's/.*VERSION = "\(.*\)".*/\1/')

echo -e "${YELLOW}Publishing Pretty IRB v${VERSION}...${NC}"

# Step 1: Run tests
echo -e "${YELLOW}Running tests...${NC}"
bundle exec rspec
if [ $? -ne 0 ]; then
    echo -e "${RED}Tests failed! Fix errors before publishing.${NC}"
    exit 1
fi

# Step 2: Build gem
echo -e "${YELLOW}Building gem...${NC}"
gem build pretty_irb.gemspec
if [ ! -f "pretty_irb-${VERSION}.gem" ]; then
    echo -e "${RED}Gem build failed!${NC}"
    exit 1
fi

# Step 3: Test local install
echo -e "${YELLOW}Testing local install...${NC}"
gem install "./pretty_irb-${VERSION}.gem"
gem uninstall pretty_irb --force

# Step 4: Push to RubyGems
echo -e "${YELLOW}Pushing to RubyGems...${NC}"
gem push "pretty_irb-${VERSION}.gem"
if [ $? -ne 0 ]; then
    echo -e "${RED}Push failed!${NC}"
    exit 1
fi

# Step 5: Verify
echo -e "${YELLOW}Verifying on RubyGems...${NC}"
sleep 5
gem search pretty_irb -r

echo -e "${GREEN}✓ Successfully published Pretty IRB v${VERSION}!${NC}"
echo -e "${GREEN}Install with: gem install pretty_irb${NC}"
```

Usage:
```bash
chmod +x publish.sh
./publish.sh
```

---

## PowerShell Publishing Script

Save as `publish.ps1`:

```powershell
# Get version from version.rb
$versionMatch = Select-String -Path "lib/pretty_irb/version.rb" -Pattern 'VERSION = "(.*?)"'
$VERSION = $versionMatch.Matches[0].Groups[1].Value

Write-Host "Publishing Pretty IRB v$VERSION..." -ForegroundColor Yellow

# Step 1: Run tests
Write-Host "Running tests..." -ForegroundColor Yellow
bundle exec rspec
if ($LASTEXITCODE -ne 0) {
    Write-Host "Tests failed!" -ForegroundColor Red
    exit 1
}

# Step 2: Build gem
Write-Host "Building gem..." -ForegroundColor Yellow
gem build pretty_irb.gemspec

$gemFile = "pretty_irb-$VERSION.gem"
if (!(Test-Path $gemFile)) {
    Write-Host "Gem build failed!" -ForegroundColor Red
    exit 1
}

# Step 3: Test local install
Write-Host "Testing local install..." -ForegroundColor Yellow
gem install ".\$gemFile"
gem uninstall pretty_irb --force

# Step 4: Push to RubyGems
Write-Host "Pushing to RubyGems..." -ForegroundColor Yellow
gem push $gemFile
if ($LASTEXITCODE -ne 0) {
    Write-Host "Push failed!" -ForegroundColor Red
    exit 1
}

# Step 5: Verify
Write-Host "Verifying on RubyGems..." -ForegroundColor Yellow
Start-Sleep -Seconds 5
gem search pretty_irb -r

Write-Host "✓ Successfully published Pretty IRB v$VERSION!" -ForegroundColor Green
Write-Host "Install with: gem install pretty_irb" -ForegroundColor Green
```

Usage:
```powershell
powershell -ExecutionPolicy Bypass -File publish.ps1
```

---

## Troubleshooting

### Error: "Please sign in"
**Solution**: Ensure credentials are set in `~/.gem/credentials`
```bash
cat ~/.gem/credentials  # Check if API key is there
```

### Error: "Gem already exists"
**Solution**: You're publishing the same version twice. Increment version number.

### Error: "403 Forbidden"
**Solution**: API key is invalid or expired. Get a new one from RubyGems Settings.

### Error: "Gem file not found"
**Solution**: Make sure you built the gem first with `gem build pretty_irb.gemspec`

### Can't find gem after pushing
**Solution**: RubyGems indexing takes 1-5 minutes. Wait and try:
```bash
gem search pretty_irb -r
```

---

## Best Practices

✅ **Do:**
- Test locally before publishing
- Use semantic versioning
- Keep CHANGELOG.md updated
- Write descriptive commit messages
- Tag releases in Git
- Test on multiple Ruby versions
- Keep dependencies minimal

❌ **Don't:**
- Publish major breaking changes without bumping major version
- Publish with failing tests
- Use vague version names
- Forget to update documentation
- Publish private credentials

---

## Resources

- **RubyGems.org**: https://rubygems.org
- **Gem Guides**: https://guides.rubygems.org
- **Semantic Versioning**: https://semver.org
- **Make Ruby Gems**: https://guides.rubygems.org/make-your-own-gem/

---

## Quick Reference Commands

```bash
# Build gem
gem build pretty_irb.gemspec

# Push to RubyGems (requires credentials)
gem push pretty_irb-0.1.0.gem

# Search RubyGems
gem search pretty_irb -r

# Install from RubyGems
gem install pretty_irb

# Uninstall locally
gem uninstall pretty_irb

# Check local gems
gem list pretty_irb

# View gem info
gem info pretty_irb
```

---

## Final Checklist Before Publishing

- [ ] Version updated to next release number
- [ ] All tests pass: `bundle exec rspec`
- [ ] README.md is complete and accurate
- [ ] CHANGELOG.md has entry for new version
- [ ] .gemspec file has correct metadata
- [ ] RubyGems account created
- [ ] API key saved in `~/.gem/credentials`
- [ ] Gem builds without errors: `gem build pretty_irb.gemspec`
- [ ] Local test install works
- [ ] Ready to push: `gem push pretty_irb-X.X.X.gem`

---

**You're all set to publish Pretty IRB to RubyGems!** 🚀

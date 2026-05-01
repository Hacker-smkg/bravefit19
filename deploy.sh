#!/bin/bash
# BraveFit 19 - Deploy script
# Run this once with your tokens to push to GitHub + Vercel

GITHUB_USERNAME="$1"
GITHUB_TOKEN="$2"
VERCEL_TOKEN="$3"

if [ -z "$GITHUB_USERNAME" ] || [ -z "$GITHUB_TOKEN" ] || [ -z "$VERCEL_TOKEN" ]; then
  echo "Usage: bash deploy.sh <github_username> <github_token> <vercel_token>"
  echo ""
  echo "Get tokens from:"
  echo "  GitHub:  https://github.com/settings/tokens/new  (select 'repo' scope)"
  echo "  Vercel:  https://vercel.com/account/tokens        (full access)"
  exit 1
fi

REPO="bravefit19"

echo "==> Creating GitHub repo..."
curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  https://api.github.com/user/repos \
  -d "{\"name\":\"$REPO\",\"description\":\"BraveFit 19 - Gym & Fitness Center Website\",\"private\":false}" | grep '"html_url"' | head -1

echo ""
echo "==> Pushing to GitHub..."
git remote add origin "https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$REPO.git"
git branch -M main
git push -u origin main

echo ""
echo "==> Deploying to Vercel..."
VERCEL_TOKEN=$VERCEL_TOKEN npx vercel deploy --yes --token "$VERCEL_TOKEN" --prod

echo ""
echo "✅ Done! Visit: https://$REPO.vercel.app"

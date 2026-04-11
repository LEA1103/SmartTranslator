#!/bin/bash
VERSION=$(cat VERSION)
echo "Current version: $VERSION"
git tag -a "v$VERSION" -m "Release v$VERSION"

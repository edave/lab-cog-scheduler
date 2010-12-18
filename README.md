# Setup

## Development

### Rails

Install Mongrel

	sudo gem install mongrel

## Testing

### Rails
	
Install AutoTest and add-ons

	gem "ZenTest"
	gem "autotest-growl"
	gem "autotest-fsevent"
	gem "redgreen"

### Javascript

Install [HomeBrew][homebrew] and then install Node.JS

	brew install node

Add these to your `.bash_login`

	export NODE_PATH="/usr/local/lib/node"
	export PATH="/usr/local/share/npm/bin:$PATH"
	

Add reload your `.bash_login`

	source ~/.bash_login

Install NPM, Node.JS' package manager

	brew install npm
	
Install JSLint

	npm install jslint

[homebrew]:https://github.com/mxcl/homebrew

package foo

import (
	"tool/cli"
	"tool/exec"
)

command: kbuild: {
  // prompt the user for some input
	ask: cli.Ask & {
		prompt:   "What shall be built?"
		response: string
	}
	// run an external command, starts after ask
	build: exec.Run & {
		// note the reference to ask and city here
		cmd: ["kubectl", "build", ask.response]
		stdout: string // capture stdout, don't print to the terminal
	}
	// also starts after echo, and concurrently with append
	print: cli.Print & {
		text: build.stdout // write the output to the terminal since we captured it previously
	}
}
package validator

import "regexp"

// ValidatePRName checks if the provided PR name matches the required format.
func ValidatePRName(prName string) bool {
	prNameRegex := regexp.MustCompile(`^(fix|feat|setup|doc|refactor|test|optimization)\([a-z0-9_-]+\)(!?):\ .*$`)

	return prNameRegex.MatchString(prName)
}

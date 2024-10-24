package validator

import "testing"

func TestIsValidPRName(t *testing.T) {
	t.Parallel()

	validPRNames := []string{
		"fix(bug-fix): Fixes the bug",
		"feat(new-feature): Adds a new feature",
		"doc(readme): Update README",
		"refactor(code): Refactor the code",
		"test(unit-test): Add unit tests",
		"optimization(speed): Optimize the algorithm",
		"setup(config): Setup configuration",
		"feat(new-feature)!: Adds a breaking change",
	}

	invalidPRNames := []string{
		"bugfix: Fixes the bug",
		"feat:new feature",
		"feat(new feature): Adds a new feature",
		"fix(bug):",
		"feat(bug-fix) Fixes the bug",
		"update(code): Update code",
		"feat(bug-fix)! Fixes the bug",
	}

	for _, prName := range validPRNames {
		if !ValidatePRName(prName) {
			t.Errorf("Expected valid PR name, but got invalid: %s", prName)
		}
	}

	for _, prName := range invalidPRNames {
		if ValidatePRName(prName) {
			t.Errorf("Expected invalid PR name, but got valid: %s", prName)
		}
	}
}

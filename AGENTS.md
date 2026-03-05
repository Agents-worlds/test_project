# OpenCode GitHub Automation Policy

이 저장소에서 OpenCode/에이전트는 **항상** 다음 순서를 따른다:
1) 계획을 `.sisyphus/plans/*.md`로 만든다.
2) 그 계획 내용을 그대로 GitHub Issue로 만든다(`opencode` 라벨).
3) Issue 번호로 브랜치를 만든다: `issue/<N>-<slug>`.
4) 구현 후 PR을 만들고, PR 본문 첫 줄에 `Closes #<N>`을 넣는다.
5) `gh pr merge --auto --squash --delete-branch`로 auto-merge를 건다.
6) CI(`CI / CI`)가 green이 되면 GitHub가 자동으로 merge 한다.

토큰 로딩 규칙:
- 실행 시작 시 반드시 `source ~/.github_token` 수행
- `GITHUB_TOKEN`이 있으면 `export GH_TOKEN="$GITHUB_TOKEN"` 로 동기화
- 토큰은 어떤 로그/PR 본문/커밋에도 출력하지 않는다

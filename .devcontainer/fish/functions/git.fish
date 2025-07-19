if type -q git
  function git
    if test (count $argv) -eq 0
      git status
    else if test $argv[1] = "up"
      git rev-parse --is-inside-work-tree > /dev/null 2>&1 && \
        cd (pwd)/(git rev-parse --show-cdup)
    else
      command git $argv
    end
  end
end

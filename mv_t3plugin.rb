#!/usr/bin/env ruby

require 'fileutils'

dryRun = false
removeBackups = true

# Check preconditions

abort("Usage: mv_t3plugin old_dir new_dir") if ARGV.length < 2
abort("You are not in an extension directory.") if not File.exists? "./ext_emconf.php"

oldDir = ARGV[0].gsub("/", "")
newDir = ARGV[1].gsub("/", "")

abort("The plugin to be moved does not exist.") if not Dir.exists? oldDir
abort("The new plugin name seems to be already taken.") if Dir.exists? newDir


# Replace occurences of old plugin name

puts "-> About to move plugin '#{oldDir}' to '#{newDir}'."
puts "Dry run!" if dryRun

sedParams = dryRun ? "" : "-i .sedbak"
%x[find . -type f | xargs sed #{sedParams} 's/#{oldDir}/#{newDir}/g']



abort("sed returned with an error. You may restore broken files from the .sedbak backups") if $? != 0


# Rename old plugin folder and files

FileUtils.mv(oldDir, newDir, {:noop => dryRun, :verbose => true})

renameDir = dryRun ? oldDir : newDir
filesToRename = %x[find #{renameDir} -name "*#{oldDir}*" -type f].split("\n")

filesToRename.each do |file|
  newName = file.gsub(oldDir, newDir)
  FileUtils.mv(file, newName, {:noop => dryRun, :verbose => true})
end


# Remove backup files

abort(".sedbak backup files have not been removed (removeBackups disabled)") if not removeBackups

backups = %x[find . -name "*.sedbak" -type f].split("\n")
FileUtils.rm( backups )

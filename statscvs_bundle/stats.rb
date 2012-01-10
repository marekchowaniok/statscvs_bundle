#!/usr/bin/env ruby
require "FileUtils"

class Stats

  attr_accessor :cvs_user_name, :tmp_dir, :stat_out_dir, :project, :cvsROOT

  def initialize(cvsName, tmpDir, statOutDir, projectName, cvsROOT)
    @cvs_user_name = cvsName
    @tmp_dir = tmpDir
    @stat_out_dir = statOutDir
    @project = projectName
    @cvsROOT = cvsROOT
  end


  def existing_dir (dir)
    if (Dir.exist?(dir))
         FileUtils.remove_dir(dir, true)
    end
  end

  def create_dir(dir)
    existing_dir(dir)
    FileUtils.mkdir(dir)
  end

  def checkout_code
    command = 'cvs -d:pserver:'+ self.cvs_user_name  + self.cvsROOT + ' checkout ' + self.project + '  ' + self.project
    system command
  end

  def create_cvs_log
    FileUtils.cd(self.project)
    system 'cvs log > ../logfile.log'
    FileUtils.cd('..')
  end

  def create_statcvs_files
    create_dir(self.stat_out_dir)
    command = 'java -jar ../statcvs.jar logfile.log PMMX -output-dir ' + self.stat_out_dir
    system command
  end

  def run
    create_dir(self.tmp_dir)
    FileUtils.cd(self.tmp_dir)
    checkout_code
    create_cvs_log
    create_statcvs_files

  end

  def help
    print 'This is script which checkout your CVS code and create statistics output using statcvs project (search on sourceforge )'
    print '\n\n in same directory where is this script have also statcvs.jar file (and of course ruby and java installed)'
    print "\n\nRun it as: Stats.new('CVS_user_name', 'tmp_dir', 'out_dir', 'CVS_project_name', 'CVS_ROOT_URL_see_example').run"
    print "\n\nFor example: Stats.new('john', 'tmp', 'out', 'CVSTest', '@cvs.domain.com:/path/to/repository/in/CVS').run"
  end


  if __FILE__ == $PROGRAM_NAME
    Stats.new('john', 'tmp', 'out', 'CVSTest', '@cvs.domain.com:/path/to/repository/in/CVS').help
    #Stats.new('john', 'tmp', 'out', 'CVSTest', '@cvs.domain.com:/path/to/repository/in/CVS').run

  end

end
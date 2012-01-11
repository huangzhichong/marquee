module JiraQueries

  # Get all Jira Iusse type in (Bug, Bug Sub-Task) for below projects.
  # TODO: wait for Tim to reply on Team Sports(previously we only get some of them based on their components)
  # Platform
  #   AMS/FNDAMS/10042
  #   ELS/FNDFIN/10065
  #   FUS,AUS/USER/10211
  #   EMAIL/EMAILZ/10212
  #   COMMERCE/COMMERCE/10213
  #   MOBILE/AMOB/10160
  # Markets
  #   Endurance/FNDENDR,FNDGVNG/10012,10010
  #   Camps/FNDCAMP/10030
  #   Team Sports/FNDSPORTS/10041
  #   Swimming/FNDSWIM/10060
  #   Membership/MEMB/10152
  def all_projects_bugs_query_string
    "
select distinct j1.pkey as 'key',
is1.pname as 'status',
res1.pname as 'resolution',
j1.CREATED as 'created',
j1.RESOLUTIONDATE as 'resolved',
pri1.pname as 'priority',
cfo5.customvalue as 'severity',
it1.pname as 'issue type',
cfo1.customvalue as 'Environment bug was found',
cfo2.customvalue as 'Who Found',
cfo3.customvalue as 'Market',
cfv4.numbervalue as 'L2',
cfo6.customvalue as 'Known Production Issue'
from jiraissue j1
left join priority pri1 on pri1.id = j1.priority
left join resolution res1 on res1.id = j1.resolution
left join issuestatus is1 on is1.id = j1.issuestatus
left join issuetype it1 on it1.id = j1.issuetype
left join customfieldvalue cfv1 on j1.id = cfv1.ISSUE and cfv1.CUSTOMFIELD = 10092
left join customfieldoption cfo1 on cfo1.customfield = 10092 and cfo1.id = cfv1.stringvalue
left join customfieldvalue cfv2 on j1.id = cfv2.ISSUE and cfv2.CUSTOMFIELD = 10182
left join customfieldoption cfo2 on cfo2.customfield = 10182 and cfo2.id = cfv2.stringvalue
left join customfieldvalue cfv3 on j1.id = cfv3.ISSUE and cfv3.CUSTOMFIELD = 10143
left join customfieldoption cfo3 on cfo3.customfield = 10143 and cfo3.id = cfv3.stringvalue
left join customfieldvalue cfv4 on j1.id = cfv4.ISSUE and cfv4.CUSTOMFIELD = 10046
left join customfieldvalue cfv5 on j1.id = cfv5.ISSUE and cfv5.CUSTOMFIELD = 10034
left join customfieldoption cfo5 on cfo5.customfield = 10034 and cfo5.id = cfv5.stringvalue
left join customfieldvalue cfv6 on j1.id = cfv6.ISSUE and cfv6.CUSTOMFIELD = 10346
left join customfieldoption cfo6 on cfo6.customfield = 10346 and cfo6.id = cfv6.stringvalue
where j1.issuetype in (1, 13)
and j1.PROJECT in (10042, 10065, 10211, 10212, 10213, 10160, 10012, 10010, 10030, 10041, 10060, 10152)
order by j1.created desc
"
  end

  # this is the specific handling for Framework, only get some of their components
  # Framework/FRAME/10210
  #   Components:
  #     Agency/10619
  #     Back Office/10617
  #     Comms/10620
  #     CUI/10615
  #     FBC/10618
  #     Forms/10621
  #     OMS/10616
  #     Waiver/10622
  def framework_bugs_with_specified_components_query_string
    "
select distinct j1.pkey as 'key',
is1.pname as 'status',
res1.pname as 'resolution',
j1.CREATED as 'created',
j1.RESOLUTIONDATE as 'resolved',
pri1.pname as 'priority',
cfo5.customvalue as 'severity',
it1.pname as 'issue type',
cfo1.customvalue as 'Environment bug was found',
cfo2.customvalue as 'Who Found',
cfo3.customvalue as 'Market',
cfv4.numbervalue as 'L2',
cfo6.customvalue as 'Known Production Issue'
from jiraissue j1
join nodeassociation n on n.SOURCE_NODE_ID = j1.id
  and ASSOCIATION_TYPE='IssueComponent'
  and n.SOURCE_NODE_ID in (select distinct s.SOURCE_NODE_ID from nodeassociation s where s.SINK_NODE_ID in (10619, 10617, 10620, 10615, 10618, 10621, 10616, 10622))
left join priority pri1 on pri1.id = j1.priority
left join resolution res1 on res1.id = j1.resolution
left join issuestatus is1 on is1.id = j1.issuestatus
left join issuetype it1 on it1.id = j1.issuetype
left join customfieldvalue cfv1 on j1.id = cfv1.ISSUE and cfv1.CUSTOMFIELD = 10092
left join customfieldoption cfo1 on cfo1.customfield = 10092 and cfo1.id = cfv1.stringvalue
left join customfieldvalue cfv2 on j1.id = cfv2.ISSUE and cfv2.CUSTOMFIELD = 10182
left join customfieldoption cfo2 on cfo2.customfield = 10182 and cfo2.id = cfv2.stringvalue
left join customfieldvalue cfv3 on j1.id = cfv3.ISSUE and cfv3.CUSTOMFIELD = 10143
left join customfieldoption cfo3 on cfo3.customfield = 10143 and cfo3.id = cfv3.stringvalue
left join customfieldvalue cfv4 on j1.id = cfv4.ISSUE and cfv4.CUSTOMFIELD = 10046
left join customfieldvalue cfv5 on j1.id = cfv5.ISSUE and cfv5.CUSTOMFIELD = 10034
left join customfieldoption cfo5 on cfo5.customfield = 10034 and cfo5.id = cfv5.stringvalue
left join customfieldvalue cfv6 on j1.id = cfv6.ISSUE and cfv6.CUSTOMFIELD = 10346
left join customfieldoption cfo6 on cfo6.customfield = 10346 and cfo6.id = cfv6.stringvalue
where j1.issuetype in (1, 13)
and j1.PROJECT = 10210
order by j1.created desc
"
  end

  def team_sports_bugs_with_specified_components_query_string
    "
select distinct j1.pkey as 'key',
is1.pname as 'status',
res1.pname as 'resolution',
j1.CREATED as 'created',
j1.RESOLUTIONDATE as 'resolved',
pri1.pname as 'priority',
cfo5.customvalue as 'severity',
it1.pname as 'issue type',
cfo1.customvalue as 'Environment bug was found',
cfo2.customvalue as 'Who Found',
cfo3.customvalue as 'Market',
cfv4.numbervalue as 'L2',
cfo6.customvalue as 'Known Production Issue'
from jiraissue j1
join nodeassociation n on n.SOURCE_NODE_ID = j1.id
  and ASSOCIATION_TYPE='IssueComponent'
  and n.SOURCE_NODE_ID not in (select distinct s.SOURCE_NODE_ID from nodeassociation s where s.SINK_NODE_ID in (10353, 10354, 10361))
left join priority pri1 on pri1.id = j1.priority
left join resolution res1 on res1.id = j1.resolution
left join issuestatus is1 on is1.id = j1.issuestatus
left join issuetype it1 on it1.id = j1.issuetype
left join customfieldvalue cfv1 on j1.id = cfv1.ISSUE and cfv1.CUSTOMFIELD = 10092
left join customfieldoption cfo1 on cfo1.customfield = 10092 and cfo1.id = cfv1.stringvalue
left join customfieldvalue cfv2 on j1.id = cfv2.ISSUE and cfv2.CUSTOMFIELD = 10182
left join customfieldoption cfo2 on cfo2.customfield = 10182 and cfo2.id = cfv2.stringvalue
left join customfieldvalue cfv3 on j1.id = cfv3.ISSUE and cfv3.CUSTOMFIELD = 10143
left join customfieldoption cfo3 on cfo3.customfield = 10143 and cfo3.id = cfv3.stringvalue
left join customfieldvalue cfv4 on j1.id = cfv4.ISSUE and cfv4.CUSTOMFIELD = 10046
left join customfieldvalue cfv5 on j1.id = cfv5.ISSUE and cfv5.CUSTOMFIELD = 10034
left join customfieldoption cfo5 on cfo5.customfield = 10034 and cfo5.id = cfv5.stringvalue
left join customfieldvalue cfv6 on j1.id = cfv6.ISSUE and cfv6.CUSTOMFIELD = 10346
left join customfieldoption cfo6 on cfo6.customfield = 10346 and cfo6.id = cfv6.stringvalue
where j1.issuetype in (1, 13)
and j1.PROJECT = 10041
order by j1.created desc
"
  end

  def all_closed_requirements_query_string
    "
select distinct j1.pkey as 'key',
is1.pname as 'status',
res1.pname as 'resolution',
j1.CREATED as 'created',
j1.RESOLUTIONDATE as 'resolved',
pri1.pname as 'priority',
cfo5.customvalue as 'severity',
it1.pname as 'issue type',
cfo1.customvalue as 'Environment bug was found',
cfo2.customvalue as 'Who Found',
cfo3.customvalue as 'Market',
cfv4.numbervalue as 'L2',
cfo6.customvalue as 'Known Production Issue'
from jiraissue j1
left join priority pri1 on pri1.id = j1.priority
left join resolution res1 on res1.id = j1.resolution
left join issuestatus is1 on is1.id = j1.issuestatus
left join issuetype it1 on it1.id = j1.issuetype
left join customfieldvalue cfv1 on j1.id = cfv1.ISSUE and cfv1.CUSTOMFIELD = 10092
left join customfieldoption cfo1 on cfo1.customfield = 10092 and cfo1.id = cfv1.stringvalue
left join customfieldvalue cfv2 on j1.id = cfv2.ISSUE and cfv2.CUSTOMFIELD = 10182
left join customfieldoption cfo2 on cfo2.customfield = 10182 and cfo2.id = cfv2.stringvalue
left join customfieldvalue cfv3 on j1.id = cfv3.ISSUE and cfv3.CUSTOMFIELD = 10143
left join customfieldoption cfo3 on cfo3.customfield = 10143 and cfo3.id = cfv3.stringvalue
left join customfieldvalue cfv4 on j1.id = cfv4.ISSUE and cfv4.CUSTOMFIELD = 10046
left join customfieldvalue cfv5 on j1.id = cfv5.ISSUE and cfv5.CUSTOMFIELD = 10034
left join customfieldoption cfo5 on cfo5.customfield = 10034 and cfo5.id = cfv5.stringvalue
left join customfieldvalue cfv6 on j1.id = cfv6.ISSUE and cfv6.CUSTOMFIELD = 10346
left join customfieldoption cfo6 on cfo6.customfield = 10346 and cfo6.id = cfv6.stringvalue
where j1.issuetype = 14
and j1.PROJECT in (10042, 10065, 10211, 10212, 10213, 10160, 10012, 10010, 10030, 10041, 10060, 10152, 10210)
and j1.issuestatus=6
order by j1.created desc
"
  end

  # sprints must be an array
  # e.g.,
  #   ['Sprint 41']
  #   ['Sprint 41 - Gold', 'Sprint 41 - Purple']
  def get_work_log_by_sprints_query_string(sprints)
    # 10000 in the query means jira_subtask_link

    conditions = sprints.collect{|sprint| "pv.vname='#{sprint}'"}.join(' or ')

    "
select
  j4.pkey as 'Requirement Key',
  j3.pkey as 'SubTask Key',
  wl.STARTDATE as 'Effort Start Date',
  wl.UPDATED as 'Effort Enter Date',
  wl.AUTHOR as 'Who',
  it.pname as 'SubTask Type',
  wl.timeworked,
  wl.id as 'Id'
from worklog wl
join jiraissue j3
  on j3.id = wl.issueid
join issuetype it
  on j3.issuetype = it.id  
left join issuelink il1 on il1.destination = wl.issueid
  and il1.linktype=10000
left join jiraissue j4 on j4.id = il1.source
where wl.issueid in (
  select j2.id from jiraissue j2
    join issuelink il on il.destination = j2.id
      and il.linktype=10000
      and il.source in (
        select j1.id
        from jiraissue j1
          join nodeassociation n on n.SOURCE_NODE_ID = j1.id
            and n.ASSOCIATION_TYPE='IssueFixVersion'
            and n.SINK_NODE_ID in (
              select pv.id from projectversion pv
                where #{conditions}
            )
        where j1.issuetype=14
        )
      );
    "
  end

  # sprints must be an array
  # e.g.,
  #   ['Sprint 41']
  #   ['Sprint 41 - Gold', 'Sprint 41 - Purple']
  def get_requirement_level_of_original_estimation_query_string(project, sprints)
    conditions = sprints.collect{|sprint| "pv.vname='#{sprint}'"}.join(' or ')

    "
select 
  j2.pkey as 'Requirement Key',
  j1.pkey as 'SubTask Key',
  j1.timeoriginalestimate as 'SubTask Original Estimate',
  it.pname as 'SubTask Type',
  ist2.pname as 'Requirement Status',
  ist.pname as 'SubTask Status',
  j2.id as 'Requirement Id',
  j1.id as 'Subtask Id'
from jiraissue j1
  join issuetype it on it.id = j1.issuetype
  join issuestatus ist on ist.id = j1.issuestatus
  join issuelink il1 on il1.destination = j1.id
    and il1.linktype=10000
  join jiraissue j2 on j2.id = il1.source
  join issuestatus ist2 on ist2.id = j2.issuestatus
  join nodeassociation n on n.SOURCE_NODE_ID = j2.id
    and n.ASSOCIATION_TYPE='IssueFixVersion'
    and n.SINK_NODE_ID in (
      select pv.id from projectversion pv
        where #{conditions}
      );
    "
  end

  def get_change_items_for(jira_issues)
    condition = jira_issues.join(', ')
    "
select ci.ID,
       ci.field,
       ci.oldvalue,
       ci.newvalue,
       ci.oldstring,
       ci.newstring,
       cg.author,
       cg.created,
       cg.issueid
from changeitem ci
  join changegroup cg on ci.groupid=cg.id and cg.issueid in (#{condition})
where ci.field='status';
    "
  end

  def get_work_logs_by_group_and_date_range_without_version(group, start_date, end_date)
    "
    select 
      wl.id,
      wl.author,
      wl.issueid,
      wl.startdate,
      wl.timeworked,
      u.display_name
    from worklog wl
    join cwd_user u on u.user_name = wl.author and u.credential <> 'nopass'
    where wl.startdate >= DATE('#{start_date}') and wl.startdate <= DATE('#{end_date}')
      and wl.author in (
        select child_name from cwd_membership where parent_name = '#{group}'
      );
    "
  end

  def get_work_logs_by_group_and_date_range(group, start_date, end_date, version)
    "
    select 
      wl.id,
      wl.author,
      wl.issueid,
      wl.startdate,
      wl.timeworked,
      ji.pkey,
      it.pname,
      (n.SOURCE_NODE_ID is not NULL),
      cfo.customvalue,
      cfo2.customvalue
    from worklog wl
      join jiraissue ji on ji.id = wl.issueid
      join issuetype it on it.id = ji.issuetype
      left join customfieldvalue csv on csv.customfield = 10143 and csv.issue = wl.issueid
      left join customfieldoption cfo on cfo.customfield = 10143 and cfo.id = csv.stringvalue
      left join customfieldvalue csv2 on csv2.customfield = 10092 and csv2.issue = wl.issueid
      left join customfieldoption cfo2 on cfo2.customfield = 10092 and cfo2.id = csv2.stringvalue
      left join nodeassociation n on n.SOURCE_NODE_ID = ji.id
        and n.ASSOCIATION_TYPE='IssueFixVersion'
        and n.SINK_NODE_ID in (
          select pv.id from projectversion pv
            where pv.vname='#{version}'
          )
    where wl.startdate >= DATE('#{start_date}') and wl.startdate <= DATE('#{end_date}')
      and wl.author in (
        select child_name from cwd_membership where parent_name = '#{group}'
      );
    "
  end

  def get_work_done_in_total_by_group_and_date_range(group, start_date, end_date)
    "
    select sum(wl.timeworked) 
      from worklog wl
      where wl.startdate >= DATE('#{start_date}') and wl.startdate <= DATE('#{end_date}')
        and wl.author in (
          select child_name from cwd_membership where parent_name = '#{group}'
        );
    "
  end

  def get_work_done_out_of_project_by_group_and_date_range(group, start_date, end_date, project)
    "
    select sum(wl.timeworked) 
     from worklog wl
     join project pj on pj.pname = '#{project}'
     join jiraissue ji on ji.id = wl.issueid and ji.project <> pj.id
     where wl.startdate >= DATE('#{start_date}') and wl.startdate <= DATE('#{end_date}')
     and wl.author in (
      select child_name from cwd_membership where parent_name = '#{group}'
     )
    "
  end

  def get_work_done_by_group_and_date_range_and_version(group, start_date, end_date, project, release_version)
    "
    select sum(wl.timeworked) 
     from worklog wl
     join project pj on pj.pname = '#{project}'
     join jiraissue ji on ji.id = wl.issueid and ji.project = pj.id
     join nodeassociation n on n.SOURCE_NODE_ID = ji.id
        and n.ASSOCIATION_TYPE='IssueFixVersion'
        and n.SINK_NODE_ID in (
          select pv.id from projectversion pv
            where pv.vname='#{release_version}'
          )
     where wl.startdate >= DATE('#{start_date}') and wl.startdate <= DATE('#{end_date}')
     and wl.author in (
      select child_name from cwd_membership where parent_name = '#{group}'
     )
     ;
    "
  end

  def get_work_done_out_of_version_by_group_and_date_range_and_version(group, start_date, end_date, project, release_version)
    "
    select sum(wl.timeworked) 
     from worklog wl
     join project pj on pj.pname = '#{project}'
     join jiraissue ji on ji.id = wl.issueid and ji.project = pj.id
     join nodeassociation n on n.SOURCE_NODE_ID = ji.id
        and n.ASSOCIATION_TYPE='IssueFixVersion'
        and n.SINK_NODE_ID in (
          select pv.id from projectversion pv
            where pv.vname <> '#{release_version}'
          )
     where wl.startdate >= DATE('#{start_date}') and wl.startdate <= DATE('#{end_date}')
     and wl.author in (
      select child_name from cwd_membership where parent_name = '#{group}'
     )
     ;
    "
  end

  def get_bugs_created_by_day(jira_key, date)
    "
    select count(*)
      from jiraissue ji
        where ji.issuetype in (1, 13)
          and ji.pkey like '%#{jira_key}%'
          and ji.created >= DATE('#{date - 1.days}') and ji.created <= DATE('#{date + 1.days}');
    "
  end

  def get_total_open_bugs_count(jira_key)
    "
    select count(*)
      from jiraissue ji
        where ji.issuetype in (1, 13)
          and ji.pkey like '%#{jira_key}%'
          and ji.issuestatus in (1, 3, 10005);
    "
  end

  def get_open_bugs_count_by_priority(jira_key)
    "
    select ji.priority,
      count(*)
    from jiraissue ji
    where ji.issuetype in (1, 13)
      and ji.pkey like '%#{jira_key}%'
      and ji.issuestatus in (1, 3, 10005)
    group by ji.priority;
    "
  end
end
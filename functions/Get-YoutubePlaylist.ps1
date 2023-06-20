function Get-YouTubePlaylist {
  <#
  .SYNOPSIS
  Retrieves details for a YouTube channel.

  .PARAMETER ChannelId
  The array of channels that you want to get detailed information for.
  #>
  [CmdletBinding()]
  param (
    [Parameter(ParameterSetName = 'PlaylistId')]
    [string[]] $PlaylistId,
    [switch] $Raw
  )
  $Uri = 'https://www.googleapis.com/youtube/v3/playlistItems?part=contentDetails,id,snippet,status'

  switch ($PSCmdlet.ParameterSetName) {
    'PlaylistId' {
      $Uri += '&playlistId={0}' -f ($PlaylistId -join ',')
    }
  }
  
  $results = @()
  $nextPageToken = $null
  
  do {
      if ($nextPageToken) {
          $uriWithPageToken = "$Uri&pageToken=$nextPageToken"
          Write-Verbose -Message $uriWithPageToken
          $result = Invoke-RestMethod -Uri $uriWithPageToken -Method Get -Headers (Get-AccessToken)
      } else {
          Write-Verbose -Message $Uri
          $result = Invoke-RestMethod -Uri $Uri -Method Get -Headers (Get-AccessToken)
      }
      
      if ($result.items) {
          $results += $result.items
      }
      
      $nextPageToken = $result.nextPageToken
  } while ($nextPageToken)
  
  return $results
}
